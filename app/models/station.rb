class Station < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "station"

  has_one_attached :image

end
