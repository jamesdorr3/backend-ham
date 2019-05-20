class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :food, :amount, :measure, :created_at, :updated_at, :index
end
