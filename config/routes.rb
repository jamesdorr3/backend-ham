Rails.application.routes.draw do
  resources :categories
  resources :days
  resources :goals
  resources :choices
  resources :foods
  resources :users
  resources :auth, only: [:create, :edit]
  # resources :account_activations, only: [:edit]
  get '/email_confirmation', to: 'users#email_confirmation'
  post '/search/make_choice', to: 'search#make_choice'
  # get '/search/get_nix_food', to: 'search#get_nix_food'
  get '/search/many', to: 'search#many'
  post '/reauth', to: 'auth#reauth'
  patch '/saveall', to: 'save_all#update'
  get 'search/internal_search', to: 'search#internal_search'
  get 'search/favorite_search', to: 'search#favorite_search'
  get 'days/copy/:id', to: 'days#copy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
