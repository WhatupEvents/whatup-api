Whatsup::Application.routes.draw do
  use_doorkeeper
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create] do
        post 'friends', to: 'users#friends', as: 'users_friends'
        post 'gcm_register', to: 'users#gcm_register', as: 'users_gcm_register'
      end
      resources :statuses, only: [:create]
      post 'message', to: 'gcm#message', as: 'gcm_message'
    end
  end
end
