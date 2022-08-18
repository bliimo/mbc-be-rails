class GameStreamsController < ApplicationController
  def stream
    @roulette = Roulette.find(params[:id])
  end
end
