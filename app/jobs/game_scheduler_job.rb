class GameSchedulerJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationChannel.broadcast_to(
        "all",
        # { notification: @notification.as_json(methods: [:game]) }
        { notification: notification.as_json(methods: [:game]) }
      )
  end
end


