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
      resources :users, only: [:create, :update] do
        post 'flag', to: 'users#flag', as: 'users_flag'
      end
      post 'add_friend', to: 'users#add_friend', as: 'users_add_friend'
      resources :friend_groups, only: [:index, :create, :update, :destroy]
      resources :shouts, only: [:create, :index, :update, :destroy] do
        put 'flag', to: 'shouts#flag', as: 'shouts_flag'
        put 'up', to: 'shouts#up', as: 'shouts_up'
      end
      resources :statuses, only: [:create]
      put :statuses, to: 'statuses#up', as: 'up_status'
      get :most_upped, to: 'statuses#most_upped', as: 'most_upped'
      resources :messages, only: [:index]
      get :random_messages, to: 'messages#random'
      resources :events, only: [:index, :create, :update, :destroy] do
        put :notify, to: 'events#notify', as: 'events_notify'
        put :leave, to: 'events#leave', as: 'events_leave'
        put :rsvp, to: 'events#rsvp', as: 'events_rsvp'
        put :follow_creator, to: 'events#follow_creator', as: 'events_follow_creator'
        put :check_action, to: 'events#check_action', as: 'events_check_action'
      end
      get :my_events, to: 'events#mine', as: 'events_mine'
      put 'events', to: 'events#index'
      post 'fcm_message', to: 'fcm#message'
      put 'messages_read', to: 'fcm#messages_read'
    end
  end
end
