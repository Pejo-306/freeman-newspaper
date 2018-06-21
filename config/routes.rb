Rails.application.routes.draw do
  root   'static_pages#home' 
  get    '/about',                        to: 'static_pages#about'
  get    '/signup',                       to: 'users#new'
  post   '/signup',                       to: 'users#create'
  get    '/login',                        to: 'sessions#new'
  post   '/login',                        to: 'sessions#create'
  delete '/logout',                       to: 'sessions#destroy'
  get    '/profile',                      to: 'users#show' 
  get    '/topics/exists/:name',          to: 'topics#exists'
  resources :users, except: [:new, :create]
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :edit, :create, :update]
  resources :topics, only: [:index, :show], param: :name
  resources :columns, only: [:index, :show], param: :author_id
  scope '/columns/:author_id' do
    get  '/articles', to: 'columns#show', as: 'articles'
    resources :articles, except: :index
    get  '/articles/:id/add-view', to: 'articles#add_view'
    post '/articles/:id/comments', to: 'articles#comment'
  end

  # Admin
  get '/admin', to: 'admin#index'
  namespace :admin do
    # Add any model to the admin system by adding its routes here
    # e.g.: 'resources :<model>'
    # Note: all controller actions for a model must be implemented
    # Note: do not use any additional options for the resources helpers
    # WARNING: the admin:model_manager generator depends on the comment bellow
    #          UNDER NO CIRCUMSTANCES should you alter said comment
    # -- INCLUDE RESOURCE ROUTES UNDER THIS LINE --
		resources :topics
    resources :users
  end
end

