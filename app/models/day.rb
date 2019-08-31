class Day < ApplicationRecord
  belongs_to :goal
  has_many :choices, dependent: :destroy
  has_many :foods, through: :choices
  has_many :categories, through: :choices

  def unique_categories
    self.categories.uniq
  end

  def choice_foods
    self.choices.map do |choice| # problem for sign up
      if choice.food
        {choice: choice, food: choice.food, measures: choice.food.measures}
      end
    end
  end

end
