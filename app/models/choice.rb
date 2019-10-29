class Choice < ApplicationRecord
  belongs_to :food, optional: true, counter_cache: :choice_count
  belongs_to :category

  after_commit :calculate_category_macros

  def calculate_category_macros
    self.category.calculate_macros
  end

end
