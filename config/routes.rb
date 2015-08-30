require 'resque_web'

Whatsup::Application.routes.draw do
  use_doorkeeper

  mount ResqueWeb::Engine => 'resque/web'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'friends', to: 'users#friends', as: 'users_friends'
      resources :users, only: [:create] do
        post 'gcm_register', to: 'users#gcm_register', as: 'users_gcm_register'
      end
      resources :friend_groups, only: [:index, :create, :update, :destroy]
      resources :statuses, only: [:create]
      put :statuses, to: 'statuses#up', as: 'up_status'
      resources :messages, only: [:index]
      resources :events, only: [:index, :create, :update, :destroy]
      post 'gcm_message', to: 'gcm#message', as: 'gcm_message'
    end
  end
end
