class ChoicesController < ApplicationController
  skip_before_action :authorized, only: [:update, :destroy]

  def create
    # byebug
    food = Food.find(params[:foodId])
    day = (current_user ? current_user.days.last : Day.all.first)
    choice = Choice.create(
      category_id: params[:categoryId], 
      day: day, ############################# PROBLEMS
      food: food,
      amount: food.serving_unit_amount, 
      measure: food.serving_unit_name, 
      index: Time::new.to_i)
    render json: {choice: choice, food: food}
  end
  
  def index
    choices = current_user.days.last.choices
    choices.map do |choice|
      if choice.food
        choice
      end
      id =  Rails.application.credentials.nix[:id]
      key = Rails.application.credentials.nix[:key]
      headers = {
        'Content-Type':'application/json',
        'x-app-id': id,
        'x-app-key': key
      }
      url = "https://trackapi.nutritionix.com/v2"
      
      if choice.nix_id
        resp = RestClient.get("#{url}/search/item?nix_item_id=#{choice.nix_id}", headers= headers)
      else
        resp = RestClient.post("#{url}/natural/nutrients", {'query': choice.nix_name }, headers= headers)
      end
      resp = JSON.parse(resp)['foods'][0]
      food = Food.new(
        name: resp['food_name'],
        serving_grams: resp['serving_weight_grams'],
        calories: resp['nf_calories'],
        fat: resp['nf_total_fat'],
        saturated_fat: resp['nf_saturated_fat'],
        carbs: resp['nf_total_carbohydrate'],
        protein: resp['nf_protein'],
        cholesterol: resp['nf_cholesterol'],
        dietary_fiber: resp['nf_dietary_fiber'],
        potassium: resp['nf_potassium'],
        sodium: resp['nf_sodium'],
        serving_unit_name: resp['serving_unit'],
        serving_unit_amount: resp['serving_qty'],
        brand: resp['brand_name'],
        sugars: resp['nf_sugars']
      )
      # puts "------------------#{food}-----------------"
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
    params.require(:choice).permit(:amount, :measure, :index, :category_id)
  end

end
