Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/auth/callback", to: "shopify_auth#callback"
end
