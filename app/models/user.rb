require 'rest-client'
class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: {case_sensitive: false}
  validates :username, uniqueness: {case_sensitive: false}

  has_many :goals, dependent: :destroy
  has_many :days, through: :goals
  has_many :categories, through: :days
  has_many :choices, through: :categories # destroyed by days?
  has_many :made_foods, class_name: 'Food', foreign_key: 'user_id'
  has_many :foods, through: :choices

  before_save :downcase_email_and_username
  before_destroy :disown_made_foods

  # def destroy
  #   self.disown_made_foods
  #   self.choices.delete_all
  #   self.categories.delete_all
  #   self.days.delete_all
  #   self.goals.delete_all
  #   self.delete
  # end

  def downcase_email_and_username
    self.email = self.email.downcase
    self.username = self.username.downcase
  end

  def day
    self.days.last
  end

  def goal
    day.goal
  end

  def categories
    self.day.categories
  end

  def choice_foods
    day.choices.map do |choice| # problem for sign up
      if choice.food && choice.food.measures
        measures = choice.food.measures
      else
        measures = nil
      end
      {choice: choice, food: choice.food, measures: measures}
    end if day
  end

  def create_activation_digest
    self.activation_digest = SecureRandom.urlsafe_base64
    if !self.save
      puts self.errors
    end
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(token)
    digest = self.activation_digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    self.save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    self.save!
  end

  def generate_token
    SecureRandom.hex(10)
  end

  def disown_made_foods
    self.made_foods.each do |food|
      food.user_id = nil
      food.save
    end
  end

end
