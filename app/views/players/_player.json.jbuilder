json.extract! player, :id, :game_id, :user_id, :win_status, :created_at, :updated_at
json.url player_url(player, format: :json)
