class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :food, :user_id, :amount, :measure, :created_at, :updated_at, :index
end
