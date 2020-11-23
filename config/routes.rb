Rails.application.routes.draw do

  root to: 'products#homepage'

  get 'products/homepage', to: 'products#homepage', as: 'homepage'
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "order_confirmation"

  resources :products do
    resources :reviews, only: [:new, :create]
    resources :order_items, only: [:create]
  end

  resources :order_items, only: [:index, :create, :edit, :update, :destroy]
  get 'order_items/shopping_cart', to: 'order_items#shopping_cart', as: 'shopping_cart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders, only: [:new, :create, :edit, :update, :show, :confirmation]

  resources :categories, only: [:new, :create, :index, :show]

  resources :users do
    resources :order_items, only: [:index]
  end

  get "/users/:id/manage_orders", to: "users#manage_orders", as: "manage_orders"


  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"
end
