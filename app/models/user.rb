class User < ApplicationRecord
  has_secure_password
  # validates :email, uniqueness: {case_sensitive: false}
  # validates :username, uniqueness: {case_sensitive: false}

  has_many :goals
  has_many :days, through: :goals
  has_many :choices, through: :days
  has_many :foods, through: :choices
  has_many :categories

end
