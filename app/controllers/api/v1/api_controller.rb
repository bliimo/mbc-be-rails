class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :start_logging
  after_action :end_logging
  private

  def encode_token(id)
    secret = Base64.decode64("JWTSuperSecretKey")
    payload = {"sub"=>"#{id}", "iat"=>DateTime.now.to_i, "exp"=>(DateTime.now + 7.days).to_i}
    payload = {"sub"=>id, "iat"=>DateTime.now.to_i, "exp"=>(DateTime.now + 7.days).to_i}
    token = JWT.encode(payload, secret, 'HS512')
    Token.create(token_id: token, user_id: id)
    token
  end

  def auth_header
    request.headers['Authorization']
  end
  
  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, nil, false, { algorithm: 'HS512' })
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
      user_id = decoded_hash[0]['sub']
      @user = MbcUser.find_by(id: user_id)
    end
  end

  def require_user_login
    render json: { message: 'Unauthorized' }, status: :unauthorized unless !!session_user
  end

  def start_logging
    @time = DateTime.now
    Rails.logger.debug "Start Logging"
    Rails.logger.debug "Current User: #{session_user.present? ? session_user.full_name  : 'No current user'}"
    Rails.logger.debug "Timestamp: #{@time.as_json}"
  end

  def end_logging
    Rails.logger.debug "End Logging"
    Rails.logger.debug "Current User: #{session_user.present? ? session_user.full_name  : 'No current user'}"
    Rails.logger.debug "Timestamp: #{@time.as_json}"
    Rails.logger.debug "Milliseconds elapse: #{(DateTime.now.to_f - @time.to_f) * 1000}"
  end
end
