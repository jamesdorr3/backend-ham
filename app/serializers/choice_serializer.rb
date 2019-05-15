class ChoiceSerializer < ActiveModel::Serializer
  attributes :id, :food, :user_id, :amount, :measure, :updated_at
end
