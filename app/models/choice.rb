class Choice < ApplicationRecord
  belongs_to :food, optional: true
  belongs_to :day
  belongs_to :category
  has_one :measure

  before_create :increment_choice_count
  before_destroy :decrement_choice_count

  def increment_choice_count
    # if self.food.choice_count
      self.food.choice_count += 1
    # else
    #   self.food.choice_count = 1
    # end
    self.food.save
  end

  def decrement_choice_count
    # if self.food.choice_count && self.food.choice_count > 1
      self.food.choice_count -= 1
    # else
    #   self.food.choice_count = 0
    # end
    self.food.save
  end

end
