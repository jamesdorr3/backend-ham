require 'faker'
class Food < ApplicationRecord
  has_many :choices
  # belongs_to :user
  has_many :measures

  def create_grams_measure
    Measure.find_or_create_by(
      food: self,
      amount: 1,
      grams: 1,
      name: 'grams'
    )
  end

  def increment_count
    if self.choice_count
      self.choice_count += 1
    else
      self.choice_count = self.choices.count + 1
    end
    self.save
  end

  def decrement_count
    if food.choice_count && food.choice_count > 0
      food.choice_count += 1
    else
      food.choice_count = 0
    end
    food.save
  end

  def self.find_or_create_and_update(resp)

    # if food = Food.find_by(fdcId: fdcId)
    #   food.increment_count
    #   return food
    # end

    # key = Rails.application.credentials[:usda][:key]
    # resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{fdcId}", headers= {'Content-Type':'application/json'})
    # resp = JSON.parse(resp)
    # byebug
    
    # byebug
    if resp['servingSize']
      serving_grams = resp['servingSize']
    elsif resp['foodPortions'][0]
      serving_grams = resp['foodPortions'][0]['gramWeight']
    end
    serving_grams = 1 if !serving_grams || serving_grams < 1

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

    food = Food.find_or_create_by(
      name: resp['description'],
      serving_grams: serving_grams,
      calories: calories,
      fat: fat,
      carbs: carbs,
      protein: protein,
      brand: resp['brandOwner'], ###############################
    )

    food.add_info(resp)

    return food

  end

  def add_info(resp)

    if resp['labelNutrients'] && resp['labelNutrients']["saturatedFat"]
      saturated_fat = resp['labelNutrients']["saturatedFat"]['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total saturated"}
      saturated_fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total saturated"}['amount'] * serving_grams / 100
    else
      saturated_fat = nil
    end
    
    if resp['labelNutrients'] && resp['labelNutrients']["cholesterol"]
      cholesterol = resp['labelNutrients']["cholesterol"]['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}
      cholesterol = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}['amount'] * serving_grams / 100
    else
      cholesterol = nil
    end

    if resp['labelNutrients'] && resp['labelNutrients']['fiber']
      fiber = resp['labelNutrients']['fiber']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}
      fiber = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}['amount'] * serving_grams / 100
    else
      fiber = nil
    end

    if resp['labelNutrients'] && resp['labelNutrients']['potassium']
      potassium = resp['labelNutrients']['potassium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}
      potassium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}['amount'] * serving_grams / 100
    else
      potassium = nil
    end

    if resp['labelNutrients'] && resp['labelNutrients']['sodium']
      sodium = resp['labelNutrients']['sodium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}
      sodium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}['amount'] * serving_grams / 100
    else
      sodium = nil
    end

    if resp['labelNutrients'] && resp['labelNutrients']['sugars']
      sugars = resp['labelNutrients']['sugars']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}
      sugars = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}['amount'] * serving_grams / 100
    else
      sugars = nil
    end

    if resp['labelNutrients'] && resp['labelNutrients']['calcium']
      calcium = resp['labelNutrients']['calcium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}
      calcium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}['amount'] * serving_grams / 100
    else
      calcium = nil
    end

    # if resp['labelNutrients'] && resp['labelNutrients']['iron']
    #   iron = resp['labelNutrients']['iron']['value']
    # elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}
    #   iron = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}['amount'] * serving_grams / 100
    # else
    #   iron = nil
    # end

    # if resp['labelNutrients'] && resp['labelNutrients']["transFat"]
    #   trans_fat = resp['labelNutrients']["transFat"]['value']
    # elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}
    #   trans_fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}['amount'] * serving_grams / 100
    # else
    #   trans_fat = nil
    # end

    upc = resp['gtinUpc']
    # byebug

    self.update(
      fdcId: resp['fdcId'], 
      upc: upc,  ###################################
      cholesterol: cholesterol, 
      dietary_fiber: fiber, 
      potassium: potassium, 
      saturated_fat: saturated_fat, 
      sodium: sodium, 
      sugars: sugars
    )
    # self.save
    self.increment_count 

  end
  
  def find_or_create_measures_by_resp(resp)
    if self.measures && self.measures.length > 0
      return self.measures
    end

    if resp["householdServingFullText"]
      unit_name = resp["householdServingFullText"]
    elsif resp['foodPortions'][0] && resp['foodPortions'][0]['portionDescription'] ############## UNIT NAME
      unit_name = "#{resp['foodPortions'][0]['portionDescription']}"
      unit_name = 'unit' if unit_name == 'Quantity not specified'
    else
      unit_name = 'unit'
    end

    if resp['foodClass'] == 'Branded' # success
      measures = [Measure.find_or_create_by(
        food: self,
        amount: 1,
        grams: self.serving_grams,
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
          name = 'unit'
        end
        if portion['amount']
          amount = portion['amount']
        else
          amount = 1
        end
        amount = 1 if !(amount > 0)
        measure = Measure.find_or_create_by(
          food: self,
          amount: amount,
          grams: portion['gramWeight'],
          name: name
        )
        measures.push(measure)
      end
    end
    measures.push(Measure.find_or_create_by(
      food: self,
      amount: 1,
      grams: 1,
      name: 'grams'
    ))

    return measures
    # day = (current_user ? current_user.days.last : Day.all.first)
    # if measures.first.amount
    #   amount = measures.first.amount
    # else
    #   amount = 1
    # end
    # choice = Choice.create(
    #   food: food,
    #   category_id: category_id, 
    #   day_id: params['dayId'], ############################# PROBLEMS
    #   amount: measures.first.amount, 
    #   measure_id: measures.first.id, 
    #   index: Time::new.to_i)
    # puts choice.errors.full_messages

  end

  def self.cache_from_USDA(search_term = '')
    if search_term == ''
      # dish, fruits, ingredient, vegetables
      search_term = Faker::Food.ingredient
    end
    # CacheTracker.last.update(page: CacheTracker.last.page - 1)
    total_pages = 999999
    current_page = 1
    # count = 0

    while true #(current_page <= total_pages) ## 50 foods per page

      key = Rails.application.credentials[:usda][:key]
      resp = RestClient.post("https://#{key}@api.nal.usda.gov/fdc/v1/search", {"generalSearchInput":"#{search_term}","requireAllWords":"false","pageNumber": current_page}.to_json, headers= {'Content-Type':'application/json'})
      resp = JSON.parse(resp)

      # count += 1
      total_pages = resp['totalPages']
      current_page = resp['currentPage'] + 1
      
      resp['foods'].each do |food|
        # count += 1
        if !new_food = Food.find_by(fdcId: food['fdcId'])
          
          new_food_resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{food['fdcId']}", headers= {'Content-Type':'application/json'})
          new_food_resp = JSON.parse(new_food_resp)
          # count += 1
          # byebug
          new_food = Food.find_or_create_and_update(new_food_resp)
          new_food.find_or_create_measures_by_resp(new_food_resp)
        end
        new_food.update(choice_count: 0) if new_food.choice_count == 1
        # CacheTracker.last.update(page: current_page + 1)
      end
    end
  end

end
