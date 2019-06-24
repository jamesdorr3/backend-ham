class ChoicesController < ApplicationController
  skip_before_action :authorized, only: [:update, :destroy, :create]

  def create
    # byebug
    food = Food.find(params[:foodId])
    day = (current_user ? current_user.days.last : Day.all.first)
    choice = Choice.create(
      category_id: params[:categoryId], 
      day_id: params[:dayId], ############################# PROBLEMS
      food: food,
      amount: food.serving_unit_amount, 
      measure_id: food.measures.first.id, 
      index: Time::new.to_i)
      # day = (current_user ? current_user.days.last : Day.all.first)
      # choice = Choice.create(
      #   food: food,
      #   category_id: category_id, 
      #   day: day, ############################# PROBLEMS
      #   nix_name: food.name, 
      #   fdc_id: resp['fdcId'], 
      #   amount: food.serving_unit_amount, 
      #   measure: food.serving_unit_name, 
      #   index: Time::new.to_i)
    render json: {choice: choice, food: food, measures: food.measures}
  end
  
  def index
    choices = current_user.days.last.choices
    choices.map do |choice|
      {choice: choice, food: food}
    end
    # byebug
    render json: choices
  end

  def update
    choice = Choice.find(params[:id])
    choice.update(choice_params)
    choice.save
    # byebug
  end

  def destroy
    choice = Choice.find(params[:id])
    choice.destroy
  end

  private

  def choice_params
    params.require(:choice).permit(:amount, :measure_id, :index, :category_id)
  end

end
