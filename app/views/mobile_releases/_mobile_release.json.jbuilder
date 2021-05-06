json.extract! mobile_release, :id, :build_code, :android_update_type, :ios_update_type, :android_number_of_installs, :ios_number_of_installs, :maintenance_mode, :created_at, :updated_at
json.url mobile_release_url(mobile_release, format: :json)
