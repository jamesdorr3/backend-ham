require 'faker'
require 'lemmatizer'
class Food < ApplicationRecord
  has_many :choices, dependent: :destroy
  belongs_to :user, optional: true
  has_many :measures, dependent: :destroy

  def create_grams_measure
    Measure.find_or_create_by(
      food: self,
      amount: 1,
      grams: 1,
      name: 'grams'
    )
  end

  def self.find_or_create_and_update(resp)

    # if food = Food.find_by(fdcId: fdcId)
    #   return food
    # end

    # key = Rails.application.credentials[:usda][:key]
    # resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{fdcId}", headers= {'Content-Type':'application/json'})
    # resp = JSON.parse(resp)
    # byebug
    
    # byebug
    if resp['servingSize'] # branded
      serving_grams = resp['servingSize']
    elsif resp['foodPortions'][0] # survey final
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
      brand: resp['brandOwner'],
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
      saturated_fat = 0
    end
    
    if resp['labelNutrients'] && resp['labelNutrients']["cholesterol"]
      cholesterol = resp['labelNutrients']["cholesterol"]['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}
      cholesterol = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}['amount'] * serving_grams / 100
    else
      cholesterol = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['fiber']
      fiber = resp['labelNutrients']['fiber']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}
      fiber = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}['amount'] * serving_grams / 100
    else
      fiber = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['potassium']
      potassium = resp['labelNutrients']['potassium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}
      potassium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}['amount'] * serving_grams / 100
    else
      potassium = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['sodium']
      sodium = resp['labelNutrients']['sodium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}
      sodium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}['amount'] * serving_grams / 100
    else
      sodium = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['sugars']
      sugars = resp['labelNutrients']['sugars']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}
      sugars = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}['amount'] * serving_grams / 100
    else
      sugars = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['calcium']
      calcium = resp['labelNutrients']['calcium']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}
      calcium = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}['amount'] * serving_grams / 100
    else
      calcium = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']['iron']
      iron = resp['labelNutrients']['iron']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}
      iron = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}['amount'] * serving_grams / 100
    else
      iron = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']["transFat"]
      trans_fat = resp['labelNutrients']["transFat"]['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}
      trans_fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}['amount'] * serving_grams / 100
    else
      trans_fat = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']["alcohol"]
      alcohol = resp['labelNutrients']["transFat"]['alcohol']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Alcohol, ethyl"}
      alcohol = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Alcohol, ethyl"}['amount'] * serving_grams / 100
    else
      alcohol = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']["caffeine"]
      caffeine = resp['labelNutrients']["transFat"]['caffeine']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Caffeine"}
      caffeine = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Caffeine"}['amount'] * serving_grams / 100
    else
      caffeine = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']["monosaturated fat"]
      mono_fat = resp['labelNutrients']["transFat"]["monosaturated fat"]
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total monounsaturated"}
      mono_fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total monounsaturated"}['amount'] * serving_grams / 100
    else
      mono_fat = 0
    end

    if resp['labelNutrients'] && resp['labelNutrients']["polyunsaturated fat"]
      poly_fat = resp['labelNutrients']["transFat"]["polyunsaturated fat"]
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total polyunsaturated"}
      poly_fat = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total polyunsaturated"}['amount'] * serving_grams / 100
    else
      poly_fat = 0
    end
    
    if resp['labelNutrients'] && resp['labelNutrients']["lactose"]
      lactose = resp['labelNutrients']["transFat"]["lactose"]
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Lactose"}
      lactose = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Lactose"}['amount'] * serving_grams / 100
    else
      lactose = 0
    end

    if resp['foodAttributes'] && resp['foodAttributes'][0] && resp['foodAttributes'][0]['value']
      description = resp['foodAttributes'][0]['value']
    else
      description = ''
    end

    # byebug
    additional_search_words = []
    lem = Lemmatizer.new
    more_descriptors = "#{self.name} #{self.brand} #{description}"
    more_descriptors.scan(/\w+/).each do |word|
      lemma = lem.lemma(word)
      if !more_descriptors.include?(lemma)
        additional_search_words << lemma
      end
    end

    upc = resp['gtinUpc'] ## or food code?
    # byebug

    self.update(
      fdcId: resp['fdcId'], 
      description: description,
      additional_search_words: additional_search_words.join(' '),
      upc: upc,  ###################################
      cholesterol: cholesterol, 
      dietary_fiber: fiber, 
      potassium: potassium, 
      saturated_fat: saturated_fat, 
      sodium: sodium, 
      sugars: sugars,
      calcium: calcium,
      iron: iron,
      trans_fat: trans_fat,
      alcohol: alcohol,
      caffeine: caffeine,
      mono_fat: mono_fat,
      poly_fat: poly_fat,
      lactose: lactose
    )
    # self.save

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
    unit_name = 'unit' if unit_name == ''

    if resp['servingSize']
      grams = resp['servingSize']
    else
      grams = self.serving_grams
    end

    # resp['servingSize']
    # resp['servingSizeUnit']

    if resp['foodClass'] == 'Branded' # success
      measures = [Measure.find_or_create_and_extract_numbers(
        food: self,
        amount: 1,
        grams: grams, ### make servingSize OR self.serving_grams
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
        measure = Measure.find_or_create_and_extract_numbers(
          food: self,
          amount: amount,
          grams: portion['gramWeight'],
          name: name
        )
        measures.push(measure)
      end
    end
    measures.push(Measure.find_or_create_and_extract_numbers(
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
    
    search_term = Faker::Food.ingredient if search_term == '' # dish, fruits, ingredient, vegetables

    total_pages = 999999
    current_page = 1

    while (current_page <= total_pages) ## 50 foods per page

      key = Rails.application.credentials[:usda][:key]
      resp = RestClient.post("https://#{key}@api.nal.usda.gov/fdc/v1/search", {"generalSearchInput":"#{search_term}","requireAllWords":"false","pageNumber": current_page}.to_json, headers= {'Content-Type':'application/json'})
      resp = JSON.parse(resp)

      total_pages = resp['totalPages']
      current_page = resp['currentPage'] + 1
      
      resp['foods'].each do |food|
        if !new_food = Food.find_by(fdcId: food['fdcId'])
          
          new_food_resp = RestClient.get("https://#{key}@api.nal.usda.gov/fdc/v1/#{food['fdcId']}", headers= {'Content-Type':'application/json'})
          new_food_resp = JSON.parse(new_food_resp)

          new_food = Food.find_or_create_and_update(new_food_resp)
          new_food.find_or_create_measures_by_resp(new_food_resp)
        end
        new_food.update(choice_count: 0) if new_food.choice_count == 1

      end
    end
  end

end
