class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for Roulette.find(params[:id]) if params[:id].present?
    stream_for "ROULETTE" if params[:roulette].present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
