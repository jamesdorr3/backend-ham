class Category < ApplicationRecord
  belongs_to :user, dependent: :delete
  has_many :choices
end
