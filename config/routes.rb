Rails.application.routes.draw do
  resources :choices
  resources :foods
  resources :users
  resources :auth
  get '/search', to: 'search#search'
  get '/auto', to: 'autocomplete#search'
  post '/reauth', to: 'auth#reauth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
