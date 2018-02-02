Rails.application.routes.draw do
  root 'users#new' # TODO: change the root path
  get    '/signup', to: 'users#new'
  post   '/signup', to: 'users#create'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: [:new, :create]
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :edit, :create, :update]
end

