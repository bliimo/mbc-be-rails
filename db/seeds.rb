User.create(
  email: 'admin@playboy.com',
  name: 'Laurence Bautista',
  contact_number: '09096969696',
  password: 'Password@123',
  username: 'laurence_admin',
  gender: 0,
  birthday: Date.today,
  role: 0,
  status: 0
)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?