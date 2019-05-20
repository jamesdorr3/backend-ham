Rails.application.routes.draw do
  resources :categories
  resources :days
  resources :goals
  resources :choices
  resources :foods
  resources :users
  resources :auth
  get '/search/make_choice', to: 'search#make_choice'
  # get '/search/get_nix_food', to: 'search#get_nix_food'
  get '/search/many', to: 'search#many'
  post '/reauth', to: 'auth#reauth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
