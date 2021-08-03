class Question < ApplicationRecord
  belongs_to :quiz_game
  has_one_attached :image
  has_many :question_choices, dependent: :destroy
  accepts_nested_attributes_for :question_choices, allow_destroy: true

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end
end
