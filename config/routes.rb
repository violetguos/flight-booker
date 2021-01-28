Rails.application.routes.draw do
  resources :passengers
  resources :bookings
  resources :flights
  resources :charges do
    member do
      get 'success'
    end
  end

  root 'flights#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
