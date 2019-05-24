require 'rest-client'
require 'json'

class SearchController < ApplicationController
  skip_before_action :authorized

  def many
    search_phrase = params['q']
    id =  Rails.application.credentials.nix[:id]
    key = Rails.application.credentials.nix[:key]
    headers = {
      'Content-Type':'application/json',
      'x-app-id': id,
      'x-app-key': key
    }
    url = "https://trackapi.nutritionix.com/v2"

    resp = RestClient.get("#{url}/search/instant?query=#{search_phrase}", headers= headers)
    # puts '#####################'
    # puts resp
    # puts '#####################'
    render json: resp

  end

  def make_choice
    category_id = params['categoryId']
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
    
    if search_name
      resp = RestClient.post("#{url}/natural/nutrients", {'query': search_name }, headers= headers)
    end
    if search_id
      resp = RestClient.get("#{url}/search/item?nix_item_id=#{search_id}", headers= headers)
    end
    resp = JSON.parse(resp)['foods'][0]
    # puts resp
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
    day = (current_user ? current_user.days.last : Day.all.first)
    choice = Choice.create(
      category_id: category_id, 
      day: day, ############################# PROBLEMS
      nix_name: food.name, 
      nix_id: resp["nix_item_id"], 
      amount: food.serving_unit_amount, 
      measure: food.serving_unit_name, 
      index: Time::new.to_i)
    # puts choice.errors.full_messages
    # to_render = {choice: choice, food: food}
    # byebug 
    render json: {choice: choice, food: food}
  end
  
  # def get_nix_food
  #   search_name = params['name']
  #   search_id = params['id']
  #   id =  Rails.application.credentials.nix[:id]
  #   key = Rails.application.credentials.nix[:key]
  #   headers = {
  #     'Content-Type':'application/json',
  #     'x-app-id': id,
  #     'x-app-key': key
  #   }
  #   url = "https://trackapi.nutritionix.com/v2"
    
  #   if search_name
  #     resp = RestClient.post("#{url}/natural/nutrients", {'query': search_name }, headers= headers)
  #   end
  #   if search_id
  #     resp = RestClient.get("#{url}/search/item?nix_item_id=#{search_id}", headers= headers)
  #   end
  #   resp = JSON.parse(resp)['foods'][0]
  #   # puts resp
  #   food = Food.new(
  #     name: resp['food_name'],
  #     serving_grams: resp['serving_weight_grams'],
  #     calories: resp['nf_calories'],
  #     fat: resp['nf_total_fat'],
  #     saturated_fat: resp['nf_saturated_fat'],
  #     carbs: resp['nf_total_carbohydrate'],
  #     protein: resp['nf_protein'],
  #     cholesterol: resp['nf_cholesterol'],
  #     dietary_fiber: resp['nf_dietary_fiber'],
  #     potassium: resp['nf_potassium'],
  #     sodium: resp['nf_sodium'],
  #     serving_unit_name: resp['serving_unit'],
  #     serving_unit_amount: resp['serving_qty'],
  #     brand: resp['brand_name'],
  #     sugars: resp['nf_sugars']
  #   )
  #   render json: food
  # end

end
