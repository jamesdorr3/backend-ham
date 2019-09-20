class Category < ApplicationRecord
  belongs_to :day
  has_many :choices, dependent: :destroy

  def dup_with_choices(day)
    new_category = self.dup
    new_category.day = day
    new_category.save!
    self.choices.each do |choice|
      new_choice = choice.dup
      new_choice.category = new_category
      new_choice.save!
    end
  end

  def self.migrate_to_dynamic_categories ## Make all categories
    Day.all.each do |day|
      Category.create(day: day, index: 0, name: "Breakfast") if not Category.find_by(day: day, name: "Breakfast")
      Category.create(day: day, index: 1, name: "Lunch") if not Category.find_by(day: day, name: "Lunch")
      Category.create(day: day, index: 2, name: "Snacks") if not Category.find_by(day: day, name: "Snacks")
      Category.create(day: day, index: 3, name: "Dinner") if not Category.find_by(day: day, name: "Dinner")
    end

    Choice.all.each do |choice|
      day = Day.find(choice.day_id)
      category = choice.category
      day_category = day.categories.find_by(name: category.name)
      if day_category
        choice.update(category: day_category)
      else
        new_category = Category.create(name: category.name, user_id: choice.category.user_id, day: day)
        choice.update(category: new_category)
      end
    end

    Category.all.each do |cat|
      if not cat.day
        cat.destroy
      end
    end
  end

  def self.calculate_macros
    Category.all.each do |cat|
      cat.calculate_macros
    end
  end

  def calculate_macros
    self.calories = 0
    self.fat = 0
    self.carbs = 0
    self.protein = 0
    self.choices.each do |choice|
      food = choice.food
      measure = Measure.find(choice.measure_id)
      grams = measure.grams * choice.amount
      servings = grams / food.serving_grams
      calories = servings * food.calories
      self.calories += calories
      fat = servings * food.fat
      self.fat += fat
      carbs = servings * food.carbs
      self.carbs += carbs
      protein = servings * food.protein
      self.protein += protein
    end
    self.save
  end

end
