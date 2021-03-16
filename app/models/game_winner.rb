class GameWinner < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "game_winner"
end
