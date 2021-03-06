Rails.application.routes.draw do
  root "static_pages#home"
  get "password_resets/new"
  get "password_resets/edit"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "users/new"
  get "sessions/new"

  resources :users
  resources :account_activations, only: %i(edit)
  resources :password_resets, except: %i(show destroy)
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
  resources :followers, only: %i(index)
  resources :followings, only: %i(index)
end
