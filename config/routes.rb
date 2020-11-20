Rails.application.routes.draw do

  root to: 'products#homepage'

  get 'products/homepage', to: 'products#homepage', as: 'homepage'

  resources :products do
    resources :reviews, only: [:create]
    resources :order_items, only: [:create]
  end

  resources :order_items, only: [:index, :create, :update, :destroy]
  get 'order_items/shopping_cart', to: 'order_items#shopping_cart', as: 'shopping_cart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders

  resources :categories, only: [:new, :create, :index, :show]
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"
end
