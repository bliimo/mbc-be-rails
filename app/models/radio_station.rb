class RadioStation < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "radio_station"
end
