require 'rest-client'
require 'json'

class SearchController < ApplicationController
  skip_before_action :authorized

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
    category_id = params['categoryId']
    search_id = params['fdcId']
    key = Rails.application.credentials[:usda][:key]
    resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{search_id}", headers= {'Content-Type':'application/json'})
    resp = JSON.parse(resp)

    if resp["householdServingFullText"]
      unit_name = resp["householdServingFullText"]
    elsif resp['foodPortions'][0] && resp['foodPortions'][0]['portionDescription'] ############## UNIT NAME
      unit_name = "#{resp['foodPortions'][0]['portionDescription']}"
      unit_name = 'unit' if unit_name == 'Quantity not specified'
    else
      unit_name = 'unit'
    end

    if resp['servingSize']
      serving_grams = resp['servingSize']
    elsif resp['foodPortions'][0]
      serving_grams = resp['foodPortions'][0]['gramWeight']
    end

    if resp['labelNutrients'] && resp['labelNutrients']['fat']
      fat = resp['labelNutrients']['fat']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Total lipid (fat)'} ### FAT
      fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Total lipid (fat)'}['amount'] * serving_grams * 0.01
    else
      fat = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['carbohydrates']
      carbs = resp['labelNutrients']['carbohydrates']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Carbohydrate, by difference'}
      carbs = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Carbohydrate, by difference'}['amount'] * serving_grams * 0.01
    else
      carbs = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['protein']
      protein = resp['labelNutrients']['protein']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Protein'}
      protein = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Protein'}['amount'] * serving_grams * 0.01
    else
      protein = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Energy'}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == 'Energy'}['amount'] * serving_grams / 100
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
      # serving_unit_name: unit_name,
      # serving_unit_amount: 1,
      brand: resp['brandOwner'],
      # sugars: sugars,
      # calcium: calcium,
      # iron: iron,
      # trans_fat: transFat
    )
    if resp['foodClass'] == 'Branded' # success
      measures = [Measure.find_or_create_by(
        food: food,
        amount: 1,
        grams: serving_grams,
        name: unit_name,
      )]
    else
      measures = []
      resp['foodPortions'].each do |portion| # success
        if portion['portionDescription']
          name = portion['portionDescription']
        elsif portion['modifier']
          name = portion['modifier']
        else
          name = 'ATTENTION'
        end
        measure = Measure.find_or_create_by(
          food: food,
          amount: portion['amount'],
          grams: portion['gramWeight'],
          name: name
        )
        measures.push(measure)
      end
    end
    measures.push(Measure.find_or_create_by(
      food: food,
      amount: 1,
      grams: 1,
      name: 'grams'
    ))
    day = (current_user ? current_user.days.last : Day.all.first)
    if measures.first.amount
      amount = measures.first.amount
    else
      amount = 1
    end
    choice = Choice.create(
      food: food,
      category_id: category_id, 
      day_id: params['dayId'], ############################# PROBLEMS
      amount: measures.first.amount, 
      measure_id: measures.first.id, 
      index: Time::new.to_i)
    # puts choice.errors.full_messages
    # to_render = {choice: choice, food: food}
    render json: {choice: choice, food: food, resp: resp, measures: measures}
  end

end
