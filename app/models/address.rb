class Address < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "address"
end
