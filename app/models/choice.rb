class Choice < ApplicationRecord
  belongs_to :day
  belongs_to :food, optional: true
  belongs_to :category
end
