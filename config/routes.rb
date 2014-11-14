Whatsup::Application.routes.draw do
  use_doorkeeper
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create] do
        post 'friends', to: 'users#friends', as: 'users_friends'
      end
      resources :statuses, only: [:create]
    end
  end
end
