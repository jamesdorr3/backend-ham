class Choice < ApplicationRecord
  belongs_to :food, optional: true, counter_cache: :choice_count
  belongs_to :category

  # before_create :increment_choice_count
  before_destroy :decrement_choice_count
  after_commit :calculate_category_macros

  def calculate_category_macros
    self.category.calculate_macros
  end

  # def increment_choice_count
  #   # if self.food.choice_count
  #     self.food.choice_count += 1
  #   # else
  #   #   self.food.choice_count = 1
  #   # end
  #   self.food.save
  # end

  def decrement_choice_count
    # if self.food.choice_count && self.food.choice_count > 1
      self.food.choice_count -= 1
    # else
    #   self.food.choice_count = 0
    # end
    self.food.save
  end

end
