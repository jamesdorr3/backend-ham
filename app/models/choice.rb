class Choice < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :food
end
