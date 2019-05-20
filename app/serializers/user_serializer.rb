class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :goals, :days, :last_day, :last_day_choices_and_foods, :last_day_categories

  

end
