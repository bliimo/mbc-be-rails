class UserStatusChannel < ApplicationCable::Channel
  def subscribed
    user = MbcUser.find_by_id(params[:user_id])
    stream_for user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
