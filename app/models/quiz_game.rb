class QuizGame < ApplicationRecord
  has_one_attached :image

  belongs_to :city, class_name: 'City', foreign_key: :city_id
  belongs_to :sponsor, class_name: 'Sponsor', foreign_key: :sponsor_id
  belongs_to :radio_station, class_name: 'RadioStation', foreign_key: :radio_station_id
  
  enum status: ["active", "inactive"]
end
