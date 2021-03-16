class Api::V1::GameController < Api::V1::ApiController

  def create_game
    # allow entering the game
    puts "Initializing"
    game_record = GameRecord.new game_params
    game_record.start_time = DateTime.now + params[:game][:seconds].to_i.seconds
    
    time = params[:game][:seconds].to_i + GameRecord.lobby_time
    puts "Total countdown time" + time.to_s

    puts "saving game record"
    if game_record.save
      render json: game_record
      start_count_down(game_record)
    else
      render json: game_record.errors, status: :unprocessable_entity
    end
    
  end

  def join_game
    game_record = GameRecord.find_by_game_id(params[:game_id])
    if game_record.present?
      render json: game_record
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
    puts "Setting countdown"
          
    time = params[:game][:seconds].to_i + GameRecord.lobby_time
    puts time.to_s

    Thread.new do
      sleep time
      puts "Countdown finished"

      # check all joined users
      puts "Getting all users"
      players = Player.where(game_id: game_record.game_id)

      # generate winner 
      # get number of players
      player_count = players.count
      number_of_winners = game_record.number_of_winners
      number_of_winners = player_count if player_count < game_record.number_of_winners

      puts "Player count: " + player_count.to_s
      puts "Number of winners: " + number_of_winners.to_s

      puts "Generating random indexes"
      indexes = []
      while indexes.count < number_of_winners
        random_index = Faker::Number.between(from: 0, to: player_count - 1)
        indexes.push(random_index) if !indexes.include? random_index
        puts "generated index: " + random_index.to_s
      end

      winners = indexes.map do |item|
        players[item]
      end
      
      # broadcast winner
      puts "broadcasting"
      GameChannel.broadcast_to(
        game_params[:game_id],
        { winners: winners, player_count: player_count, players: players}
      )
      # save to database
    end
  end
end
