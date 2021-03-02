#require 'resque_web'

Whatup::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  use_doorkeeper

  #mount ResqueWeb::Engine => 'resque/web'

  root to: "home#home"

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      delete 'unregister_device', to: 'users#unregister', as: 'unregister'
      get 'download/:image_url', to: 'messages#download', as: 'image_download'
      post 'check_uniqueness', to: 'users#check_uniqueness', as: 'check_uniqueness'
      post 'get_email', to: 'users#get_email', as: 'get_email'
      post 'authenticate', to: 'users#authenticate', as: 'authenticate'
      post 'friends', to: 'users#friends', as: 'users_friends'
      resources :users, only: [:create, :update] do
        post 'flag', to: 'users#flag', as: 'users_flag'
        get 'interested', to: 'users#interested', as: 'users_interested'
      end
      post 'add_friend', to: 'users#add_friend', as: 'users_add_friend'
      resources :friend_groups, only: [:index, :create, :update, :destroy]
      resources :shouts, only: [:create, :index, :update, :destroy] do
        post 'video', to: 'shouts#video_upload', as: 'shouts_video'
        put 'block', to: 'shouts#block', as: 'shouts_block'
        put 'flag', to: 'shouts#flag', as: 'shouts_flag'
        put 'up', to: 'shouts#up', as: 'shouts_up'
      end
      resources :organizations, only: [:index]
      resources :categories, only: [:index] do
        resources :topics
      end
      resources :topics, only: [:index]
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
      resources :notifications, only: [:index, :destroy]
      get :my_events, to: 'events#mine', as: 'events_mine'
      put 'events', to: 'events#index'
      post 'fcm_message', to: 'fcm#message'
      put 'messages_read', to: 'fcm#messages_read'
    end
  end
end
