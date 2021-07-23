class QuestionChoice < ApplicationRecord

  include Rails.application.routes.url_helpers

  has_one_attached :image
  belongs_to :question

  validates :label, presence: true

  def style 
    "background-color: #{
      background_color
    }80;#{
      if image.attached?
        "
          background-image: url(\"#{ url_for(image_path)}\");
          background-color: #cccccc;
          background-repeat: no-repeat;
          background-size: cover;
          background-position: center;
        "
      end  
    });"
  end

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end
end
