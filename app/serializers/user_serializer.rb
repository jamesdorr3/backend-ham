class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :calories, :fat, :carbs, :protein
end
