require 'resque_web'

Whatsup::Application.routes.draw do
  use_doorkeeper

  mount ResqueWeb::Engine => 'resque/web'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create] do
        post 'friends', to: 'users#friends', as: 'users_friends'
        post 'friend_group', to: 'users#create_friend_group', as: 'users_create_friend_group'
        get 'friend_groups', to: 'users#friend_groups', as: 'users_friend_groups'
        post 'gcm_register', to: 'users#gcm_register', as: 'users_gcm_register'
      end
      resources :statuses, only: [:create]
      resources :messages, only: [:index]
      resources :events, only: [:index, :create, :update, :destroy]
      post 'gcm_message', to: 'gcm#message', as: 'gcm_message'
    end
  end
end
