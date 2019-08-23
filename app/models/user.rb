require 'rest-client'
class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: {case_sensitive: false}
  validates :username, uniqueness: {case_sensitive: false}

  has_many :goals
  has_many :days, through: :goals
  has_many :choices, through: :days
  has_many :foods, through: :choices
  has_many :categories

  def day
    self.days.last
  end

  def goal
    day.goal
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

  # def delete_with_dependencies
  #   self.choices.destroy_all
  #   self.categories.destroy_all
  #   self.days.destroy_all
  #   self.goals.destroy_all
  #   self.destroy
  # end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def create_activation_digest
    activation_token  = SecureRandom.urlsafe_base64
    self.activation_digest = User.digest(activation_token)
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

end
