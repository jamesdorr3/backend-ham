class Food < ApplicationRecord
  has_many :choices
  belongs_to :user
  has_many :measures

  def create_grams_measure
    Measure.find_or_create_by(
      food: self,
      amount: 1,
      grams: 1,
      name: 'grams'
    )
  end

  def self.find_or_create_resp(resp, current_user)
    if Food.find_by(fdcId: resp['fdcId'])
      puts 'YAaaaaaaaaYY'
      return
    end
    if resp["householdServingFullText"]
      unit_name = resp["householdServingFullText"]
    elsif resp['foodPortions'][0] && resp['foodPortions'][0]['portionDescription'] ############## UNIT NAME
      unit_name = "#{resp['foodPortions'][0]['portionDescription']}"
      unit_name = 'unit' if unit_name == 'Quantity not specified'
    else
      unit_name = 'unit'
    end
    
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
      user: current_user,
      name: resp['description'],
      serving_grams: serving_grams,
      calories: calories,
      fat: fat,
      carbs: carbs,
      protein: protein,
      brand: resp['brandOwner'],
    )

    # saturated_fat: saturatedFat,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total saturated"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total saturated"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    
    # cholesterol: cholesterol,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Cholesterol"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # dietary_fiber: fiber,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fiber, total dietary"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # potassium: potassium,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Potassium, K"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # sodium: sodium,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sodium, Na"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # sugars: sugars,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Sugars, total including NLEA"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # calcium: calcium,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Calcium, Ca"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # iron: iron,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Iron, Fe"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end
    # trans_fat: transFat,
    if resp['labelNutrients'] && resp['labelNutrients']['calories']
      calories = resp['labelNutrients']['calories']['value']
    elsif resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}
      calories = resp["foodNutrients"].find{|x| x["nutrient"]['name'] == "Fatty acids, total trans"}['amount'] * serving_grams / 100
    else
      calories = fat * 9 + carbs * 4 + protein * 4
    end

    if resp['gtinUpc']
      upc = resp['gtinUpc']
    else
      upc = nil
    end

    food.update(fdcId: resp['fdcId'])

    if food.choice_count
      food.choice_count += 1
    else
      food.choice_count = food.choices.count + 1
    end
    food.save
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
        if portion['amount']
          amount = portion['amount']
        else
          amount = 1
        end
        amount = 1 if !(amount > 0)
        measure = Measure.find_or_create_by(
          food: food,
          amount: amount,
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
    puts choice.errors.full_messages
  end

end
