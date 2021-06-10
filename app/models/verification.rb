class Verification < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "verification"
end
