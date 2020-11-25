Rails.application.routes.draw do

  root to: 'products#homepage'

  get 'products/homepage', to: 'products#homepage', as: 'homepage'
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "order_confirmation"

  resources :products do
    resources :reviews, only: [:new, :create]
    resources :order_items, only: [:create]
  end

  post "/products/:id/retire", to: "products#retire", as: "retire"

  get 'products/:id/reviews/new', to: 'reviews#new'
  post 'products/:id/reviews', to: 'reviews#create'
  patch "products/:id/hide", to: "products#hide", as: "hide_product"

  resources :order_items, only: [:index, :create, :edit, :update, :destroy]
  get 'order_items/shopping_cart', to: 'order_items#shopping_cart', as: 'shopping_cart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders, only: [:create, :edit, :update, :show, :confirmation]

  patch "/orders/:id/complete_order", to: "orders#complete_order", as: "complete_order"
  patch "/orders/:id/cancel_order", to: "orders#cancel_order", as: "cancel_order"

  resources :categories, only: [:new, :create, :index, :show]

  resources :users do
    resources :order_items, only: [:index]
  end

  get "/users/:id/manage_orders", to: "users#manage_orders", as: "manage_orders"


  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_github_callback"
  delete "/logout", to: "users#destroy", as: "logout"

end
