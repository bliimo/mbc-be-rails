Rails.application.routes.draw do
  resources :mobile_releases
  resources :notifications
  resources :players
  resources :game_records
  mount ActionCable.server => '/cable'

  resources :messages
  resources :streaming_rooms do
    member do
      get :viewers
      get :chats
      get :gifts
    end
  end
  resources :playmates do
    member do
      get :conversations
      get :exclusive_contents
      get :streams
    end
  end
  resources :billing_addresses
  resources :buyers do
    end
  resources :option_items
  resources :option_groups do
    end
  resources :variations
  resources :products do
        member do
      post :upload_image
      post :add_tags
      delete :delete_tag
      delete :delete_image
    end
  end
  resources :categories
  resources :merchants do
      member do
      post :upload_image
      delete :delete_image
    end
  end
  resources :users, path: 'user' do
    member do
      patch :toggle_verification
    end
  end

  get 'profile', to: 'profile#index'
  get 'profile/change_password'
  patch 'profile/update_password'
  devise_for :users
  get 'users/:id' => 'users#show'
  get 'home/index'
  root 'home#index'

  get 'confirm_email/:token', to: 'email_handler#confirm_email'

  namespace :api do
    namespace :v1 do
      get 'auth/connection_test'
      post 'auth/login'
      post 'auth/login_with_facebook'
      post 'auth/login_with_google'
      post 'auth/login_with_apple'
      post 'auth/register_user'
      post 'auth/register_playmate'
      post 'auth/register_as_merchant'
      post 'auth/verify_code'
      post 'auth/resend_verification_code'
      post 'auth/forgot_password'
      post 'auth/verify_forgot_password_code'
      post 'auth/change_password'
      post 'auth/resend_forgot_password_code'
      get 'auth/profile'

      post 'game/create_game'
      get 'game/join_game'
      post 'game/spin_game'
      post 'game/broadcast_game'
      post 'game/override_timer'
      get 'game/:id', to: 'game#show'

      resources :notifications do
        collection do
          get :in_app_notifications
        end
        member do
          post :read
        end
      end

      resources :mobile_releases do
        collection do
          get :check_for_updates
          post :register_new_install
        end
      end

      resources :stations
      
    end
  end
end
