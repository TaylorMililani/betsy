Rails.application.routes.draw do

  root to: 'products#homepage'

  get 'products/homepage', to: 'products#homepage', as: 'homepage'

  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders
end
