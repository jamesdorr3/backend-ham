class Day < ApplicationRecord
  belongs_to :goal
  has_many :categories, dependent: :destroy
  has_many :choices, through: :categories
  has_many :foods, through: :choices

  after_create :generate_categories

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

  def generate_categories
    Category.create(day: self, index: 0, name: "Breakfast")
    Category.create(day: self, index: 1, name: "Lunch")
    Category.create(day: self, index: 2, name: "Snacks")
    Category.create(day: self, index: 3, name: "Dinner")
  end

end
