class UserChannel < ApplicationCable::Channel
  def subscribed

    stream_for session_user if session_user
    user = session_user
    if user.present?
      user.online_status = "Online"
      user.last_online = DateTime.now
      user.save
    end
  end

  def unsubscribed
    user = session_user
    if user.present?
      user.online_status = "Offline"
      user.last_online = DateTime.now
      user.save
    end
  end

  private
  def decoded_token
    if params[:token]
      begin
        JWT.decode(params[:token], 'pngtek_solutions_2020', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        []
      end
    else
      []
    end
  end

  def session_user
    decoded_hash = decoded_token
    unless decoded_hash.empty?
      user_id = decoded_hash[0]['id']
      @user = User.find_by(id: user_id)
    end
  end
end
