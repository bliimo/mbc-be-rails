class RadioStation < ActiveRecord::Base
  belongs_to :network
  belongs_to :city
  belongs_to :admin_user
  has_one_attached :image

  default_scope {order(updated_at: :desc)}

  has_many :quiz_games, :foreign_key => "radio_station_id", :class_name => "QuizGame" 
  enum status: ["Active", "Inactive"]

  validates :name, presence: true

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end

end