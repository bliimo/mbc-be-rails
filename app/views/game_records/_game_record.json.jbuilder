json.extract! game_record, :id, :game_id, :start_time, :winners, :created_at, :updated_at
json.url game_record_url(game_record, format: :json)
