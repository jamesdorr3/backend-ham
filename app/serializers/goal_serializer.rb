class GoalSerializer < ActiveModel::Serializer
  attributes :id, :calories, :fat, :carbs, :protein
  has_one :user
end
