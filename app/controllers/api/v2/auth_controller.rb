class Api::V2::AuthController < Api::V2::ApiController
  require 'open-uri'
  include ImagesHelper

  before_action :require_user_login, only: [:profile, :logout]

  def connection_test
    Rails.logger.debug "connection test action"
    UserChannel.broadcast_to(
      User.find(21),
      { type: "LOGOUT"}
    )
  end

  def login
    user = User.where(login_type: "Email").find_by(email: params[:email])
    if user.present? && user.valid_password?(params[:password])
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      handle_valid_credential(user)
    else
      render json: { message: 'Log in failed! Invalid email or password.' }, status: :unauthorized
    end
  end

  def login_with_facebook
    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    
    result = JSON.parse Net::HTTP.get(URI.parse("https://graph.facebook.com/me?fields=id,name,first_name,last_name,email,picture.type(large)&access_token=#{access_token}"))
    return render json: {message: "Invalid access key", fb_response: result}, status: :unprocessable_entity if result["error"].present?
    # return render json: result
    user = User.where(login_type: "Facebook").find_by(auth_id: result["id"])
    if user.present?
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      handle_valid_credential(user)
    else
      user = User.new(
        email: result['email'] || "#{DateTime.now.to_i}#{Faker::Alphanumeric.alphanumeric(number: 3)}@mbc.app",
        first_name: result["first_name"],
        last_name: result["last_name"],
        gender: "Undisclosed",
        country: "Philippines",
        region_id: 1,
        province_id: 1,
        city_id: 1,
        status: "Active",
        login_type: "Facebook",
        auth_id: result["id"],
        verified_at: DateTime.now
      )
      if user.save 
        user.image.attach({
          io: URI.open(result["picture"]["data"]["url"]),
          filename: "#{DateTime.now.to_i}_facebook_image.jpg"
        })
        handle_valid_credential(user)
      else
        existing_user = User.find_by_email(result["email"])
        if existing_user.present?
          render json: {message: "Email has already been used in #{existing_user.login_type} login"}, status: :unprocessable_entity
        else
          render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def login_with_google
    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    decoded = JWT.decode(access_token, nil, false)
    result = decoded.first
    return render json: {message: "Invalid token", decoded: decoded}, status: :unprocessable_entity if result.blank?

    user = User.where(login_type: "Google").find_by(email: result["email"])
    if user.present?
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      handle_valid_credential(user)
    else
      user = User.new(
        email: result['email'],
        first_name: result["given_name"],
        last_name: result["family_name"],
        gender: "Undisclosed",
        country: "Philippines",
        region_id: 1,
        province_id: 1,
        city_id: 1,
        status: "Active",
        login_type: "Google",
        auth_id: result["id"],
        verified_at: DateTime.now
      )

      if user.save
        user.image.attach({
          io: URI.open(result["picture"]),
          filename: "#{DateTime.now.to_i}_google_image.jpg"
        })
        handle_valid_credential(user)
      else
        existing_user = User.find_by_email(result["email"])
        if existing_user.present?
          render json: {message: "Email has already been used in #{existing_user.login_type} login"}, status: :unprocessable_entity
        else
          render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def login_with_apple

    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    decoded = JWT.decode(access_token, nil, false)
    result = decoded.first
    return render json: {message: "Invalid token", decoded: decoded}, status: :unprocessable_entity if result.blank?

    user = User.where(login_type: "Apple").find_by(email: result["email"])
    
    if user.present?
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      handle_valid_credential(user)
    else
      user = User.new(
        email: result['email'],
        first_name: params["first_name"],
        last_name: params["last_name"],
        gender: "Undisclosed",
        country: "Philippines",
        region_id: 1,
        province_id: 1,
        city_id: 1,
        status: "Active",
        login_type: "Apple",
        auth_id: result["id"],
        verified_at: DateTime.now
      )

      if user.save
        handle_valid_credential(user)
      else
        existing_user = User.find_by_email(result["email"])
        if existing_user.present?
          render json: {message: "Email has already been used in #{existing_user.login_type} login"}, status: :unprocessable_entity
        else
          render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
        end
      end
    end
  end

  def register
    user = User.new(user_params)
    user.role = "Player"
    user.status = "Active"
    
    
    if user.save 
      user.generate_verification_code
      if params[:image].present? 
        user.image = base64_to_file(params[:image])
        user.save
      end
      UserNotifierMailer.send_confirmation_email(user).deliver
      handle_valid_credential(user)
      
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def resend_confirmation_email
    user = User.find_by(email: params[:email])
    if user.verified_at.present?
      render json: {message: "User is already verified"}, status: :unprocessable_entity
    else
      UserNotifierMailer.send_confirmation_email(user).deliver
      render json: {message: "Email resent"}
    end
  end

  def profile
      render(
        json: session_user,
        methods: %i[image_path editable],
        include: [:city],
        status: :ok
      )
  end

  def logout
    user = session_user
    user.token = nil
    user.save
  end

  def verify_code
    verification_code = params[:verification_code]
    user = User.find_by(verification_code: verification_code)
    if user.present? && verification_code.present?
      user.verified_at = Date.today
      user.verification_code = nil
      user.save
      render json: user, status: :ok
    else
      render json: { message: 'No user found' }, status: :unprocessable_entity
    end
  end

  def resend_verification_code
    user = User.find_by(email: params[:email])
    if user.present?
      if user.verified_at.present?
        render json: { message: 'User was already verified' }, status: :unprocessable_entity
      else
        UserNotifierMailer.send_verification_code(user, request).deliver
        render json: { message: 'Verification code has been successfully resent!' }, status: :ok
      end
    else
      render json: { message: 'No user found' }, status: :unprocessable_entity
    end
  end

  def forgot_password
    user = User.where(login_type: 'email').find_by(email: params[:email])
    if user.present?
      user.generate_verification_code
      user.save(validate: false)
      UserNotifierMailer.send_verification_code(user, request).deliver
      render json: { message: 'Verification code has been successfully sent!' }, status: :ok
    else
      render json: { message: 'No user found' }, status: :unprocessable_entity
    end
  end

  def resend_forgot_password_code
    user = User.find_by(email: params[:email])
    if user.present?
      if user.code_expired?
        user.generate_verification_code
        user.save(validate: false)
      end
      UserNotifierMailer.send_verification_code(user, request).deliver
      render json: { message: 'Verification code has been successfully sent!' }, status: :ok
    else
      render json: { message: 'No user found' }, status: :unprocessable_entity
    end
  end

  def verify_forgot_password_code
    verification_code = params[:verification_code]
    return render json: { message: 'Code not valid' }, status: :unprocessable_entity if verification_code.blank?
    user = User.find_by(verification_code: verification_code)
    if user.present?
      if user.code_expired?
        render json: { message: 'code expired' }, status: :unprocessable_entity
      else
        render json: { message: 'Code valid', user: user }, status: :ok
      end
    else
      render json: { message: 'Code not valid' }, status: :unprocessable_entity
    end
  end

  def change_password
    code = params[:code]
    user = User.find_by(verification_code: code)
    if user.present? && code.present?
      if user.code_expired?
        render json: { message: 'code expired' }, status: :unprocessable_entity
      else
        user.password = params[:password]
        user.verification_sent_at = nil
        user.verification_code = nil
        if user.save
          render json: user, status: :ok
        else
          render json: user.errors.full_messages, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'Code not valid' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :contact_number,
      :first_name,
      :last_name,
      :gender,
      :birthday,
      :country,
      :region_id,
      :province_id,
      :city_id,
      :password
    )
  end

  def device_info_params
    params.require(:device_info).permit(
      :manufacturer,
      :device_id,
      :device_name,
      :brand,
      :ip_address,
      :model,
      :mac_address,
      :carrier,
      :system_version,
    )
  end

  def handle_valid_credential(user)
    token = encode_token({ id: user.id, time: Time.now.to_i })
    if user.token.blank? || params[:login_type] == "OVERRIDE_TOKEN"
      user.token = token
      
      user.last_login = DateTime.now
      user.update(device_info_params)
      render json: { user: user.as_json(methods: :image_path), token: token }, status: :ok
      UserChannel.broadcast_to(
        user,
        { type: "LOGOUT", token: user.token}
      )
    else
      render json: {type: "ALREADY_LOGGED_IN", message: "You are currently logged in another device"}, status: :unauthorized
    end
  end
end
