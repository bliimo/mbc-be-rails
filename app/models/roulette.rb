class Roulette < ApplicationRecord
  has_one_attached :background
  has_one_attached :winner_background
  has_one_attached :banner
  has_one_attached :top_banner

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
  
  validates :location_restriction_type, presence: true, if: :location_restriction?
  validates :text_description, presence: true, if: :location_restriction?
  validates :name, presence: true 
  validates :number_of_winner, presence: true 
  validates :price, presence: true 
  validates :schedule, presence: true 
  validates :redemption_details, presence: true 
  validates :dti_permit, presence: true 
  validate :city_presense

  before_save :validate_location_restriction
  validate :validate_number_of_winner
  validate :validate_schedule

  def city_presense
    if location_restriction?
      if city_ids.count.zero?
        errors.add(:cities, "Game must have at least 1 city..")
      end
    end
  end

  def validate_number_of_winner
    errors.add(:number_of_winner, "can't be less than 1") if number_of_winner.present? && number_of_winner < 1
  end

  def validate_schedule
    if new_record?
      errors.add(:schedule, "can't be in the past") if schedule.present? && schedule < DateTime.now
    end
  end

  def validate_location_restriction
    if !self.location_restriction?
      self.cities.destroy_all
      self.location_restriction_type = nil
      self.text_description = nil
    end
  end

  def background_path
    return Rails.application.routes.url_helpers.rails_blob_path(background, only_path: true) if background.attached?
  end

  def winner_background_path
    return Rails.application.routes.url_helpers.rails_blob_path(winner_background, only_path: true) if winner_background.attached?
  end

  def banner_path
    return Rails.application.routes.url_helpers.rails_blob_path(banner, only_path: true) if banner.attached?
  end

  def top_banner_path
    return Rails.application.routes.url_helpers.rails_blob_path(top_banner, only_path: true) if top_banner.attached?
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
        cities: {include: :province},
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
        :remaining_seconds,
        :banner_path,
        :top_banner_path
      ]
    }
  end
end
