class GameListChannel < ApplicationCable::Channel
  def subscribed
    stream_for params[:mbc_game]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
