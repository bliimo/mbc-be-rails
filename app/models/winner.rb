class Winner < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "player_winner"
end
