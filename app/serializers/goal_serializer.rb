class GoalSerializer < ActiveModel::Serializer
  attributes :id, :calories, :fat, :carbs, :protein, :name
  has_one :user
end
