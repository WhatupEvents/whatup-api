require 'resque_web'

Whatsup::Application.routes.draw do
  use_doorkeeper

  mount ResqueWeb::Engine => 'resque/web'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get ':image_url', to: 'messages#download', as: 'image_download'
      post 'friends', to: 'users#friends', as: 'users_friends'
      resources :users, only: [:create] do
        post 'fcm_register', to: 'users#fcm_register', as: 'users_fcm_register'
      end
      resources :friend_groups, only: [:index, :create, :update, :destroy]
      resources :shouts, only: [:create, :index, :update]
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
