class DaySerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at, :goal_id, :choice_foods, :unique_categories, :date, :categories
  belongs_to :goal
end
