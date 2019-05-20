class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :food, :amount, :measure, :created_at, :updated_at, :index
  belongs_to :food
  belongs_to :category
  belongs_to :day
end
