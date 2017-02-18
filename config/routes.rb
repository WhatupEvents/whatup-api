require 'resque_web'

Whatsup::Application.routes.draw do
  use_doorkeeper

  mount ResqueWeb::Engine => 'resque/web'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      delete 'unregister_device', to: 'users#unregister', as: 'unregister'
      get 'download/:image_url', to: 'messages#download', as: 'image_download'
      post 'check_uniqueness', to: 'users#check_uniqueness', as: 'check_uniqueness'
      post 'authenticate', to: 'users#authenticate', as: 'authenticate'
      post 'friends', to: 'users#friends', as: 'users_friends'
      resources :users, only: [:create, :update]
      post 'add_friend', to: 'users#add_friend', as: 'users_add_friend'
      resources :friend_groups, only: [:index, :create, :update, :destroy]
      resources :shouts, only: [:create, :index, :update] do
        put 'flag', to: 'shouts#flag', as: 'shouts_flag'
        put 'up', to: 'shouts#up', as: 'shouts_up'
      end
      resources :statuses, only: [:create]
      put :statuses, to: 'statuses#up', as: 'up_status'
      get :most_upped, to: 'statuses#most_upped', as: 'most_upped'
      resources :messages, only: [:index]
      get :random_messages, to: 'messages#random'
      resources :events, only: [:index, :create, :update, :destroy] do
        get :notify, to: 'events#notify', as: 'events_notify'
      end
      put 'events', to: 'events#index'
      put 'leave_events/:id', to: 'events#leave'
      post 'fcm_message', to: 'fcm#message'
    end
  end
end
