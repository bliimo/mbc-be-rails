class Api::V1::GameController < Api::V1::ApiController

  def create_game
    # allow entering the game
    Rails.logger.debug "Initializing"
    game_record = GameRecord.new game_params
    game_record.start_time = DateTime.now + params[:game][:seconds].to_i.seconds
    
    time = params[:game][:seconds].to_i + GameRecord.lobby_time
    Rails.logger.debug "Total countdown time" + time.to_s

    Rails.logger.debug "saving game record"
    if game_record.save
      render json: game_record
      start_count_down(game_record)
    else
      render json: game_record.errors, status: :unprocessable_entity
    end
  end

  def show
    game_record = GameRecord.find_by_game_id(params[:id])
    if game_record.present?
      render json: game_record, methods: [:players]
    else
      render json: "Not found", status: 404
    end
  end

  def join_game
    game_record = GameRecord.find_by_game_id(params[:game_id])
    if game_record.present?
      render json: game_record, methods: [:remaining_time, :current_time]
    else
      render json: "Not found", status: 404
    end
  end

  def spin_game
    player = Player.new(player_params)
    # save the player
    if player.save
      render json: player
    else
      render json: player.errors, status: :unprocessable_entity
    end
  end

  def broadcast_game
    GameListChannel.broadcast_to(
        "MBC_GAME",
        { message: "GAME_LIST_UPDATED"}
      )
    render json: {message: 'Game broadcasted'}
  end

  private
  def game_params
    params.require(:game).permit(
      :game_id,
      :number_of_winners
    )
  end

  def player_params
    params.require(:player).permit(
      :game_id,
      :user_id
    )
  end

  def start_count_down(game_record)
    # set time 
    Rails.logger.debug "Setting countdown"
          
    time = params[:game][:seconds].to_i + GameRecord.lobby_time
    Rails.logger.debug time.to_s

    Thread.new do
      sleep time
      Rails.logger.debug "Countdown finished"

      # check all joined users
      Rails.logger.debug "Getting all users"
      players = Player.where(game_id: game_record.game_id)

      # generate winner 
      # get number of players
      player_count = players.count
      number_of_winners = game_record.number_of_winners
      number_of_winners = player_count if player_count < game_record.number_of_winners

      Rails.logger.debug "Player count: " + player_count.to_s
      Rails.logger.debug "Number of winners: " + number_of_winners.to_s

      Rails.logger.debug "Generating random indexes"
      indexes = []
      while indexes.count < number_of_winners
        random_index = Faker::Number.between(from: 0, to: player_count - 1)
        indexes.push(random_index) if !indexes.include? random_index
        Rails.logger.debug "generated index: " + random_index.to_s
      end

      # create game winner
      game_winner = GameWinner.create(game_id: game_params[:game_id])
      # create player winner

      winners = indexes.map do |item|
        mbc_user = MbcUser.find_by_id(players[item].user_id)
        name = mbc_user.full_name if mbc_user.present?
        Winner.create(user_id: players[item].user_id, game_winner_game_winner_id: game_winner.game_winner_id, full_name: name)
        players[item].win_status = "Win"
        players[item].save
        players[item]
      end
      
      # broadcast winner
      Rails.logger.debug "broadcasting"
      GameChannel.broadcast_to(
        game_params[:game_id],
        { winners: winners, player_count: player_count, players: players}
      )
      # save to database
    end
  end
end
