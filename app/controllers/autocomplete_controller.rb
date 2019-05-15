require 'rest-client'
class AutocompleteController < ApplicationController

  def search
    search_phrase = params['q']
    id =  Rails.application.credentials.nix[:id]
    key = Rails.application.credentials.nix[:key]
    headers = {
      'Content-Type':'application/json',
      'x-app-id': id,
      'x-app-key': key
    }
    url = "https://trackapi.nutritionix.com/v2"

    resp = RestClient.get("#{url}/search/instant?query=#{search_phrase}", headers= headers)
    render json: resp

  end

end
