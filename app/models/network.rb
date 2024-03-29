class Network < ApplicationRecord
  has_many :radio_stations, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  has_one_attached :image
  has_and_belongs_to_many :admin_users
  accepts_nested_attributes_for :admin_users
  accepts_nested_attributes_for :radio_stations, allow_destroy: true

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end

  def self.serializer
    {
      include: [
        {
          radio_stations: {
            include: [
              :city
            ],
            methods: [:image_path]
          }
        }
      ],
      methods: [:image_path]
    }
  end

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end

end
