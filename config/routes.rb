Rails.application.routes.draw do
  # --- Redirect naked domain to www (SEO canonical) ---
  constraints(host: "neighborfoodapp.com") do
    match "/(*path)", to: redirect { |params, req|
      "https://www.neighborfoodapp.com/#{params[:path]}"
    }, via: :all, status: 301
  end

  devise_for :users

  root to: "foods#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  resources :foods, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :claims, only: [:new, :create]
    resources :reviews, only: [:new, :create]
    resources :tags,    only: [:index]
    resources :reviews, only: [:create, :destroy, :show]
  end

  resources :claims, only: [:index, :show, :edit, :update, :destroy]

  resources :users, only: [:show, :edit, :update] do
    resources :reviews, only: [:show]
  end

  get "user/:id/foods", to: "users#user_foods", as: :user_foods
end
