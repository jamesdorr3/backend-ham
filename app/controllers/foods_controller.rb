class FoodsController < ApplicationController

  skip_before_action :authorized, only: [:create]

  def index
    render :json => Food.all
  end

  def create
    food = Food.find_or_create_by(food_params)
    measure = Measure.create(
      food: food,
      amount: food.serving_unit_amount,
      grams: food.serving_grams,
      name: food.serving_unit_name
    )
    food.create_grams_measure
    choice = Choice.create(food: food, category_id: params[:categoryId], day: current_user.days.last,
    amount: food.serving_unit_amount, 
    measure_id: measure.id, 
    index: Time::new.to_i)
    render json: {choice: choice, food: food, measures: food.measures}
  end

  private

  def food_params
    params[:food][:user_id] = current_user.id
    params.require(:food).permit(:name, :serving_grams, :serving_unit_name, 
    :serving_unit_amount, :brand, :calories, :fat, :carbs, :protein, 
    :cholesterol, :dietary_fiber, :potassium, :saturated_fat, :sodium,
    :sugars, :unit_size, :upc, :user_id)
  end

end
