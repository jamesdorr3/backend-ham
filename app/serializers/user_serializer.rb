class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :goals, :days, :day, :choice_foods, :categories, :goal

  

end
