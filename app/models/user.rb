class User < ApplicationRecord
  has_secure_password
  # validates :email, uniqueness: {case_sensitive: false}
  # validates :username, uniqueness: {case_sensitive: false}

  has_many :goals
  has_many :days, through: :goals
  has_many :choices, through: :days
  has_many :foods, through: :choices
  has_many :categories
  has_many :foods

  def last_day
    self.days.last
  end

  def last_day_choices_and_foods
    last_day.choices.map do |choice|
      {choice: choice, food: choice.food}
    end
  end

  def last_day_categories
    last_day.categories
  end

end
