class Food < ApplicationRecord
  has_many :choices
  belongs_to :user
  has_many :measures

  def create_grams_measure
    Measure.find_or_create_by(
      food: self,
      amount: 1,
      grams: 1,
      name: 'grams'
    )
  end
end
