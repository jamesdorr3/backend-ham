require 'rest-client'
require 'json'

class SearchController < ApplicationController
  skip_before_action :authorized

  def favorite_search
    search_phrase = params['q'].downcase
    if current_user && current_user.foods
      foods = current_user.foods.find_all{|x| x.name.downcase.include?(search_phrase) || search_phrase.include?(x.name.downcase)}
      foods = foods.select{|x| x.choices.count > 0}
      foods.each do |food|
        if !food.choice_count
          food.choice_count = food.choices.count
          food.save
        end
      end
      foods = foods.sort { |a, b| b.choice_count <=> a.choice_count }
      render json: foods.uniq[0,10]
    else
      foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase) || search_phrase.include?(x.name.downcase)}
      foods = foods.sort { |a, b| b.choices.count <=> a.choices.count }
      render json: foods.uniq[0,10]
    end
  end

  def internal_search
    search_phrase = params['q'].downcase
    foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase) || search_phrase.include?(x.name.downcase)}
    # foods = foods.select{|x| x.choices.count > 0}
    foods = foods.sort { |a, b| b.choices.count <=> a.choices.count }
    render json: {internal: foods}
  end

  def many
    key = Rails.application.credentials[:usda][:key]
    search_phrase = params['q']
    page_number = params['pageNumber']
    resp = RestClient.post("https://#{key}@api.nal.usda.gov/fdc/v1/search", {"generalSearchInput":"#{search_phrase}","requireAllWords":"true","pageNumber":"#{page_number}"}.to_json, headers= {'Content-Type':'application/json'})
    # foods = Food.all.find_all{|x| x.name.downcase.include?(search_phrase)}
    resp = JSON.parse(resp)
    # byebug
    render json: {common: resp["foods"], resp: resp, current_page: resp['currentPage'], total_pages: resp['totalPages']}
  end

  def make_choice

    food = Food.find_or_create_and_update(params['fdcId'])
    measures = food.measures

    day = (current_user ? current_user.days.last : Day.all.first) ############# nil ?
    # byebug
    if measures.first && measures.first.amount
      amount = measures.first.amount
    else
      amount = 1
    end
    puts food, measures
    choice = Choice.create(
      food: food,
      category_id: params['categoryId'], 
      day_id: params['dayId'], ############################# PROBLEMS ? 
      amount: amount, 
      measure_id: measures.first.id, 
      index: Time::new.to_i)
    puts choice.errors.full_messages
    # to_render = {choice: choice, food: food}
    render json: {choice: choice, food: food, measures: measures}
  end

end
