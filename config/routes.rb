Rails.application.routes.draw do

  get 'welcome/index'
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :sessions => 'sessions' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  resources :quiz
  resources :users
  resources :themes
  resources :rankings
  resources :parliamentarians
  resources :profile
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  post 'ranking' => 'rankings#index'
  get ':state' => 'parliamentarians#parliamentarians_per_state'

  post 'parliamentarians_search' => 'parliamentarians#index'

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
end
