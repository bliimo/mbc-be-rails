class City < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "city_municipality"
end
