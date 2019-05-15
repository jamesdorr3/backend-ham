require 'rest-client'
class SearchController < ApplicationController

  def search
    search_phrase = params['q']

    id =  Rails.application.credentials.nix[:id]
    puts id
    puts '------------------'
    key = Rails.application.credentials.nix[:key]
    puts key

    headers = {
      'Content-Type':'application/json',
      'x-app-id': id,
      'x-app-key': key
    }

    url = "https://trackapi.nutritionix.com/v2"

    resp = RestClient.post("#{url}/natural/nutrients", {'query': search_phrase }, headers= headers)
    # byebug
    render json: resp

  end

end
