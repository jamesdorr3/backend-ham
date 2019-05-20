class Food < ApplicationRecord
  has_many :choices
  belongs_to :user
end
