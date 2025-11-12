Rails.application.routes.draw do
  devise_for :users
  root to: "foods#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


  resources :foods, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :claims, only: [:new, :create]
    resources :reviews, only: [:new, :create]
    resources :tags, only: [:index]
  end

  resources :claims, only: [:index, :show, :edit, :update, :destroy]

  resources :users, only: [:show]
  get "user/:id/foods", to: "users#user_foods", as: :user_foods

end
