class Question < ApplicationRecord
  belongs_to :quiz_game
  has_one_attached :image
  has_many :question_choices, dependent: :destroy
  accepts_nested_attributes_for :question_choices, allow_destroy: true

end
