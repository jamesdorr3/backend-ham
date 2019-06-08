class Food < ApplicationRecord
  has_many :choices
  belongs_to :user
  has_many :measures
end
