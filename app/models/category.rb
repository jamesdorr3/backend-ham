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
end
