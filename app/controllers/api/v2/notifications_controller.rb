class Api::V2::NotificationsController < Api::V2::ApiController
  def index
    render json: Notification.all.order(updated_at: :desc)
  end
end
