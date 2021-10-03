class Api::V2::RoulettesController < Api::V2::ApiController

  before_action :require_user_login
  before_action :set_roulette, only: [:show, :spin_game]

  def index
    render json: Roulette.scheduled_today.available.as_json(Roulette.serializer), status: :ok
  end

  def show 
    user = session_user
    participant = RouletteParticipant.find_or_create_by(
      roulette_id: @roulette.id, 
      user_id: user.id
    )
    GameChannel.broadcast_to(
      @roulette,
      { type: "PLAYER_JOIN", participants: @roulette.roulette_participants.as_json(include: :user, methods: [:status, :win_status])}
    )
    render json: @roulette.as_json(Roulette.serializer), status: :ok
  end

  def spin_game
    participant = RouletteParticipant.find_or_create_by(
      roulette_id: @roulette.id,
      user_id: session_user.id
    )
    participant.spin_at = DateTime.now if participant.spin_at.blank?
    if participant.save
      GameChannel.broadcast_to(
        @roulette,
        { type: "PLAYER_SPIN", participants: @roulette.roulette_participants.as_json(include: :user, methods: [:status, :win_status])}
      )
      render json: participant, status: :ok
    else
      render json: participant.error.full_messages, status: :unprocessable_entity
    end
  end

  def my_prices
    render json: session_user.roulette_participants.wins.order(created_at: :desc).as_json(include: [:roulette])
  end

  def start_game

  end

  private
  def set_roulette 
    @roulette = Roulette.find(params[:id])
  end

end
