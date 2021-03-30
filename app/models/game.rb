class Game < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "game"
end
