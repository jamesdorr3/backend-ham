class DaySerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :goal
end
