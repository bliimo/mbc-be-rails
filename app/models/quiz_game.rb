class QuizGame < ApplicationRecord
  has_one_attached :image

  belongs_to :city, class_name: 'City', foreign_key: :city_id
  belongs_to :sponsor
  belongs_to :radio_station, class_name: 'RadioStation', foreign_key: :radio_station_id

  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  enum status: ["active", "inactive"]

  validates :title, presence: true

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end

  def self.serializer
    {
      include: [
        :sponsor,
        :city,
        :radio_station,
        {
          questions: {
            include: [
              {
                question_choices: {
                  include: [],
                  methods: [:image_path]
                }
              }
            ],
            methods: [:image_path]
          }
        }
      ],
      methods: [
        :image_path
      ]
    }
  end
end
