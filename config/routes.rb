Olimpiada::Application.routes.draw do
  root to: 'splash#index' 

  get '/logout', to: 'splash#logout'
  post '/authenticate', to: 'splash#authenticate'

  resources :users, only: [:new, :create, :show, :edit, :update] do
    collection do
      post 'search'
    end

    member do 
      post 'follow'
      post 'unfollow'
    end
    
  	resources :study_sessions, only: [:create]
  end

  namespace :admin do
    root to: 'users#index'
    resources :users, only: [:index] do
      resources :study_sessions, only: [:index, :edit, :update, :destroy]
    end
  end

  namespace :master do
  	root to: 'universities#index'
  	resources :universities
    resources :admins
  end
end
