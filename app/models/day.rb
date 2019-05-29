class Day < ApplicationRecord
  belongs_to :goal
  has_many :choices
  has_many :foods, through: :choices
  has_many :categories, through: :choices

  def unique_categories
    self.categories.uniq
  end

  def choice_foods
    self.choices.map do |choice| # problem for sign up
      if choice.food
        {choice: choice, food: choice.food}
      # else
      #   id =  Rails.application.credentials.nix[:id]
      #   key = Rails.application.credentials.nix[:key]
      #   headers = {
      #     'Content-Type':'application/json',
      #     'x-app-id': id,
      #     'x-app-key': key
      #   }
      #   url = "https://trackapi.nutritionix.com/v2"
      #   if choice.nix_id
      #     resp = RestClient.get("#{url}/search/item?nix_item_id=#{choice.nix_id}", headers= headers)
      #   else
      #     resp = RestClient.post("#{url}/natural/nutrients", {'query': choice.nix_name }, headers= headers)
      #   end
      #   resp = JSON.parse(resp)['foods'][0]
      #   puts '#################################################################################'
      #   puts resp
      #   puts '#################################################################################'
        
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
      #   {choice: choice, food: food}
      end
    end
  end

end
