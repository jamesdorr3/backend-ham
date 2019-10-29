class FoodsController < ApplicationController

  skip_before_action :authorized, only: [:create,:index]

  def index
    search_phrase = params['q'].downcase

    def search(foods, search_phrase)
      return foods if search_phrase == ''
      foods.find_all do |food|

        search_phrase = search_phrase.downcase
        food_name = food.name.downcase
        food_brand = food.brand.downcase if food.brand

        food_name.include?(search_phrase) || 
        search_phrase.include?(food_name) || 
        (food_brand.include?(search_phrase) if (food.brand && food.brand.length > 0)) || 
        (search_phrase.include?(food_brand) if (food.brand && food.brand.length > 0))

      end
    end

    def check_choice_count(foods)
      foods.each do |food|
        if !(food.choice_count && food.choice_count >= 0)
          food.choice_count = food.choices.count
          food.save
        end
      end
    end

    def select_favorites(foods,search_phrase)
      favorites = search(foods, search_phrase)
      check_choice_count(foods)
      favorites = favorites.sort {|a, b| b.choice_count <=> a.choice_count}
      return favorites.uniq[0,10]
    end

    if search_phrase.match?(/\A\d{8,}\Z/)
      if food = Food.find_by(upc: search_phrase)
        foods = []
        foods << food
        render json: {favorites: [food], internal: nil}
      end
    elsif search_phrase.match?(/\A(\d{1,3}.){2}\d{1,3}\Z/)
      search_phrase = search_phrase.split(/\D/)
      fat = search_phrase[0].to_i
      carbs = search_phrase[1].to_i
      protein = search_phrase[2].to_i
      macro_sum = fat + carbs + protein
      fat = fat*100 / macro_sum
      carbs = carbs*100 / macro_sum
      protein = protein*100 / macro_sum
      foods = Food.all.select do |food|
        macro_sum = food.fat + food.carbs + food.protein
        food.fat*100 / macro_sum < fat + 1 &&
        food.fat*100 / macro_sum > fat - 1 &&
        food.carbs*100 / macro_sum > carbs - 1 &&
        food.carbs*100 / macro_sum > carbs - 1 &&
        food.protein*100 / macro_sum > protein - 1 &&
        food.protein*100 / macro_sum > protein - 1
      end
      # categories = Category.all.select do |cat|
      #   macro_sum = cat.fat + cat.carbs + cat.protein
      #   cat.fat*100 / macro_sum < fat + 1 &&
      #   cat.fat*100 / macro_sum > fat - 1 &&
      #   cat.carbs*100 / macro_sum > carbs - 1 &&
      #   cat.carbs*100 / macro_sum > carbs - 1 &&
      #   cat.protein*100 / macro_sum > protein - 1 &&
      #   cat.protein*100 / macro_sum > protein - 1
      # end
      # byebug
      render json: {favorites: foods, internal: nil}
    else
      if current_user && current_user.foods.length >= 10
        favorites = select_favorites(current_user.foods, search_phrase)
      else
        favorites = select_favorites(Food.all, search_phrase)
      end
      
      if search_phrase == ''
        internal = []
      else
        internal = search(Food.all, search_phrase)
        check_choice_count(internal)
        # internal = internal.filter{|x| !favorites.map(&:id).include?(x['id'])}
      end
      render json: {favorites: favorites, internal: nil}
    end
  end

  def create
    food = Food.find_or_create_by(food_params)
    # byebug
    measure = Measure.create(
      food: food,
      amount: params["serving_unit_amount"],
      grams: params["serving_grams"],
      name: params["serving_unit_name"]
    )
    food.create_grams_measure
    choice = Choice.create(
      food: food, 
      category_id: params[:categoryId], 
      day_id: params[:dayId],
      amount: params["serving_unit_amount"], 
      measure_id: measure.id, 
      index: Time::new.to_i
    )
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
