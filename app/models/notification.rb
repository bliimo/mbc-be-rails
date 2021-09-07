class Notification < ApplicationRecord
  validates :title, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {maximum: 250}
  # validates :schedule, presence: true  
  default_scope { order(created_at: :desc) }

  belongs_to :user, class_name: "MbcUser", foreign_key: "user_id", optional: true
  has_many :user_notifications, dependent: :destroy

  scope :to_be_notified, -> { where(schedule: (DateTime.now - 1.days)...DateTime.now)}

  attr_accessor :current_user_id

  after_save :notify_user

  def game
    Game.find_by_game_id(game_id)
  end

  def is_read
    return true if UserNotification.find_by(user_id: current_user_id, notification_id: id).present?
    return false
  end

  def notify_user
    NotificationChannel.broadcast_to(
      "all",
      { notification: as_json(methods: [:game]) }
    )
  end
end
