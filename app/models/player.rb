class Player < ApplicationRecord
  enum win_status: ["Default", "Win", "Lose"]

  validates :game_id, presence: true
  validates :user_id, presence: true

end
