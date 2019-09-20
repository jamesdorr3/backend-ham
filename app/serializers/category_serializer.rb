class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :index
  has_one :user
end
