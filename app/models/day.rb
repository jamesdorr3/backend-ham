class Day < ApplicationRecord
  belongs_to :goal
  has_many :choices
  has_many :foods, through: :choices
end
