require 'rest-client'
require 'json'

class SearchController < ApplicationController
  skip_before_action :authorized

  # def many
  #   search_phrase = params['q']
  #   id =  Rails.application.credentials.nix[:id]
  #   key = Rails.application.credentials.nix[:key]
  #   headers = {
  #     'Content-Type':'application/json',
  #     'x-app-id': id,
  #     'x-app-key': key
  #   }
  #   url = "https://trackapi.nutritionix.com/v2"

  #   resp = RestClient.get("#{url}/search/instant?query=#{search_phrase}", headers= headers)
  #   # puts '#####################'
  #   # puts resp
  #   # puts '#####################'
  #   foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase.downcase)}
  #   resp = JSON.parse(resp)
  #   resp[:internal] = foods
  #   render json: resp

  # end

  def internal_search
    search_phrase = params['q'].downcase
    foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase) || search_phrase.include?(x.name.downcase)}
    render json: {internal: foods}
  end

  def many
    key = Rails.application.credentials[:usda][:key]
    search_phrase = params['q']
    resp = RestClient.post("https://#{key}@api.nal.usda.gov/fdc/v1/search", {"generalSearchInput":"#{search_phrase}"}.to_json, headers= {'Content-Type':'application/json'})
    # foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase)}
    # byebug
    resp = JSON.parse(resp)
    render json: {common: resp["foods"]}
  end

  def make_choice
    # byebug
    category_id = params['categoryId']
    search_id = params['fdcId']
    key = Rails.application.credentials[:usda][:key]
    resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{search_id}", headers= {'Content-Type':'application/json'})
    resp = JSON.parse(resp)
    # byebug
    if resp['foodClass'] == 'Branded'
      unit_name = resp["householdServingFullText"]
      serving_grams = resp['servingSize']
      resp['labelNutrients'].each{|nutrient| eval("#{nutrient[0]} = #{nutrient[1]['value']}")}
    else
      # unit_name = 
    end
    if resp['foodPortions'][0] && resp['foodPortions'][0]['portionDescription'] ############## UNIT NAME
      unit_name = "#{resp['foodPortions'][0]['portionDescription']}"
      unit_name = 'unit' if unit_name == 'Quantity not specified'

    else
      unit_name = 'unit'
      serving_grams = 99999
    end

    elsif resp['foodPortions'][0] 
      serving_grams = resp['foodPortions'][0]['gramWeight']
    end
    if resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Total lipid (fat)'} ### FAT
      fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Total lipid (fat)'}['amount'] * serving_grams * 0.01
    else
      byebug
    end
    if resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Carbohydrate, by difference'}
      carbs = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Carbohydrate, by difference'}['amount'] * serving_grams * 0.01
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Sugars, total including NLEA'}
      carbs = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Sugars, total including NLEA'}['amount'] * serving_grams * 0.01
    else
      byebug
    end
    if resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Protein'}
      protein = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Protein'}['amount'] * serving_grams * 0.01
    else
      byebug
    end
    if resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Energy'}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Energy'}['amount'] * serving_grams * 0.01
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # byebug
    food = Food.find_or_create_by(
      user: current_user,
      name: resp['description'],
      serving_grams: serving_grams,
      calories: calories,
      fat: fat,
      # saturated_fat: saturatedFat,
      carbs: carbs,
      protein: protein,
      # cholesterol: cholesterol,
      # dietary_fiber: fiber,
      # potassium: potassium,
      # sodium: sodium,
      serving_unit_name: unit_name,
      serving_unit_amount: 1,
      brand: resp['brandOwner'],
      # sugars: sugars,
      # calcium: calcium,
      # iron: iron,
      # trans_fat: transFat
      )
    day = (current_user ? current_user.days.last : Day.all.first)
    choice = Choice.create(
      food: food,
      category_id: category_id, 
      day_id: params['dayId'], ############################# PROBLEMS
      nix_name: food.name, 
      nix_id: resp['fdcId'], 
      amount: food.serving_unit_amount, 
      measure: food.serving_unit_name, 
      index: Time::new.to_i)
    # puts choice.errors.full_messages
    # to_render = {choice: choice, food: food}
    # byebug 
    render json: {choice: choice, food: food, resp: resp}
  end

  # def make_choice
  #   category_id = params['categoryId']
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
  #   day = (current_user ? current_user.days.last : Day.all.first)
  #   choice = Choice.create(
  #     category_id: category_id, 
  #     day: day, ############################# PROBLEMS
  #     nix_name: food.name, 
  #     nix_id: resp["nix_item_id"], 
  #     amount: food.serving_unit_amount, 
  #     measure: food.serving_unit_name, 
  #     index: Time::new.to_i)
  #   # puts choice.errors.full_messages
  #   # to_render = {choice: choice, food: food}
  #   # byebug 
  #   render json: {choice: choice, food: food}
  # end
  
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
