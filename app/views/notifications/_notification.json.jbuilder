json.extract! notification, :id, :title, :description, :game_id, :schedule, :created_at, :updated_at
json.url notification_url(notification, format: :json)
