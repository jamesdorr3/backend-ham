Rails.application.routes.draw do
  resources :choices
  resources :foods
  resources :users
  get '/search', to: 'search#search'
  get '/auto', to: 'autocomplete#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
