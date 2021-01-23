Rails.application.routes.draw do
  resources :passengers
  resources :bookings
  resources :flights
  root 'flights#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
