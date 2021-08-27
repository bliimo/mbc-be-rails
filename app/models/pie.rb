class Pie < ApplicationRecord
  belongs_to :roulette
  has_one_attached :icon

  def icon_path
    return Rails.application.routes.url_helpers.rails_blob_path(icon, only_path: true) if icon.attached?
  end
end
