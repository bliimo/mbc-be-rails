class Roulette < ApplicationRecord
  has_one_attached :background
  has_one_attached :winner_background

  has_and_belongs_to_many :cities
  has_many :roulette_participants, dependent: :destroy
  has_many :pies, class_name: "Pie",  dependent: :destroy
  accepts_nested_attributes_for :cities
  accepts_nested_attributes_for :pies

  belongs_to :radio_station
  belongs_to :dj, class_name: "AdminUser", foreign_key: "dj_id"
  belongs_to :sponsor

  enum location_restriction_type: [:address, :gps]
  enum status: [:pending, :ready, :in_progress, :done]
  
  scope :scheduled_today, -> { where(schedule: DateTime.now.beginning_of_day...DateTime.now.end_of_day)}
  scope :available, -> { where.not(status: "done")}
  
  def background_path
    return Rails.application.routes.url_helpers.rails_blob_path(background, only_path: true) if background.attached?
  end

  def winner_background_path
    return Rails.application.routes.url_helpers.rails_blob_path(winner_background, only_path: true) if winner_background.attached?
  end

  def remaining_seconds
    if start_time.present?
       elapsed_seconds = (start_time - DateTime.now)
       return elapsed_seconds if elapsed_seconds > 0
    end
    return 0
  end

  def self.lobby_time
    30
  end

  def self.serializer
    {
      include: [
        :sponsor,
        :cities,
        pies: {
          methods: [:icon_path]
        },
        dj: {
          methods: [:image_path]
        },
        radio_station: {
          include: [
            network: {
              methods: [:image_path]
            }
          ]
        }
      ],
      methods: [
        :background_path,
        :winner_background_path, 
        :remaining_seconds
      ]
    }
  end
end
