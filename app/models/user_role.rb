class UserRole < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "users_roles"
end
