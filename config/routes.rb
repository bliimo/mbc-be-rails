Rails.application.routes.draw do
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

          resources :products do
        collection do
          get :categories
        end
      end
      resources :streaming_rooms do
        collection do
          get :private_rooms
        end
        member do
          post :buy_private_room
        end
      end
      resources :carts, only: %i[index create destroy]
      resources :tags, only: [:index]
      get 'merchant_product/products'
      get 'merchant_product/categories'
      post 'merchant_product/add_category'
      post 'merchant_product/add_product'
      post 'orders/checkout'
      get 'orders/index'
      get 'orders/:id' => 'orders#show'
      patch 'merchant/update_shop'
      post 'merchant/upload_banner'

      get 'playmates/index'
      get 'playmates/:id' => 'playmates#show'

      get 'conversations/get_conversation/:user_id' => 'conversations#get_conversation'
      post 'conversations/create_chat/:conversation_id' => 'conversations#create_chat'
      get 'conversations/get_messages/:conversation_id' => 'conversations#get_messages'
      get 'conversations/get_all_conversations'

      get 'in_app_stores/index'

      get 'in_app_currency_transactions/index'
      post 'in_app_currency_transactions/create'

      get 'gifts/index'
      post 'gifts/send_gift'

      get 'exclusive_contents' => 'exclusive_contents#index'
      get 'exclusive_contents/:id' => 'exclusive_contents#show'
      post 'exclusive_contents/:id/purchase' => 'exclusive_contents#purchase'
    end
  end
end
