class Question < ApplicationRecord
  belongs_to :quiz_game
  has_one_attached :image

end
