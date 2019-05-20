class DaySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :goal
  has_one :user
end
