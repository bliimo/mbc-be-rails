class Sponsor < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "sponsor"
end
