class FoodsController < ApplicationController

  skip_before_action :authorized, only: [:create,:index]

  def index
    search_phrase = params['q'].downcase

    def search(foods, search_phrase)
      foods.find_all do |x| 
        x.name.downcase.include?(search_phrase) || 
        search_phrase.include?(x.name.downcase) || 
        (x.brand.downcase.include?(search_phrase) if (x.brand && x.brand.length > 0)) || 
        (search_phrase.include?(x.brand.downcase) if (x.brand && x.brand.length > 0))
      end
    end

    def check_choice_count(foods)
      foods.each do |food|
        if !food.choice_count
          food.choice_count = food.choices.count
          food.save
        end
      end
    end

    def select_favorites(foods,search_phrase)
      favorites = search(foods, search_phrase)
      check_choice_count(foods)
      favorites = favorites.select{|x| x.choice_count > 0}
      favorites = favorites.sort {|a, b| b.choice_count <=> a.choice_count}
      return favorites.uniq[0,10]
    end

    if current_user && current_user.foods
      favorites = select_favorites(current_user.foods, search_phrase)
    else
      favorites = select_favorites(Food.all, search_phrase)
    end
    
    if search_phrase == ''
      internal = []
    else
      internal = search(Food.all, search_phrase)
      check_choice_count(internal)
      internal = internal.filter{|x| !favorites.map(&:id).include?(x['id'])}
    end
    render json: {favorites: favorites, internal: internal.uniq}
  end

  def create
    food = Food.find_or_create_by(food_params)
    measure = Measure.create(
      food: food,
      amount: food.serving_unit_amount,
      grams: food.serving_grams,
      name: food.serving_unit_name
    )
    food.create_grams_measure
    choice = Choice.create(food: food, category_id: params[:categoryId], day: current_user.days.last,
    amount: food.serving_unit_amount, 
    measure_id: measure.id, 
    index: Time::new.to_i)
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
