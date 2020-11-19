Rails.application.routes.draw do
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders
  
  get "auth/github", as: "github_login"
  get "auth/github/callback", to: "users#create"
end
