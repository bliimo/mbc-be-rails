class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for Roulette.find(params[:id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
