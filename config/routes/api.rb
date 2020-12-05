namespace :api do
  namespace :v1 do
    get 'auth/connection_test'
    get 'auth/validate_id_number'
    post 'auth/login'
    post 'auth/register'
    post 'auth/register'
    get 'auth/profile'
    get 'announcements/index'
    post 'announcements/read_announcement'
    post 'messages' => 'messages#create'
  end
end
