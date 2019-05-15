require 'rest-client'
require 'json'

class SearchController < ApplicationController

  def search
    search_name = params['name']
    search_id = params['id']
    id =  Rails.application.credentials.nix[:id]
    key = Rails.application.credentials.nix[:key]
    headers = {
      'Content-Type':'application/json',
      'x-app-id': id,
      'x-app-key': key
    }
    url = "https://trackapi.nutritionix.com/v2"

    # byebug
    if search_name
      resp = RestClient.post("#{url}/natural/nutrients", {'query': search_name }, headers= headers)
    end
    if search_id
      resp = RestClient.get("#{url}/search/item?nix_item_id=#{search_id}", headers= headers)
    end
    resp = JSON.parse(resp)['foods'][0]
    byebug
    food = Food.find_or_create_by(
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
      # serving_unit: resp['serving_unit'],
      # brand: resp['brand_name'],
      sugars: resp['nf_sugars']
    )

    choice = Choice.create(user_id: 1, food: food, amount: food.serving_grams, measure: 'grams')
    
    # byebug
    render json: choice

    # resp.foods[0].food_name nf_calories 
    # _cholesterol _dietary_fiber _potassium 
    # _protein _saturated_fat _sodium _sugars 
    # _total_carbohydrate _total_fat serving_unit 
    # serving_weight_grams

  end

end
