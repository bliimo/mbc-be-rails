class Api::V2::AuthController < Api::V2::ApiController
  require 'open-uri'
  include ImagesHelper

  before_action :require_user_login, only: [:profile]

  def connection_test
    Rails.logger.debug "connection test action"
    user = User.where(login_type: "Email").find_by(email: "wasayuda@mailinator.com")
    UserNotifierMailer.send_verification_code(user, request).deliver
    render json: { message: 'yep its working', user: user }, status: :ok
  end

  def login
    user = User.where(login_type: "Email").find_by(email: params[:email])
    if user.present? && user.valid_password?(params[:password])
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      render json: { user: user, token: encode_token({ id: user.id }) }, status: :ok
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
      render json: { user: user.as_json(methods: :image_path), result: result, token: encode_token({ id: user.id }) }, status: :ok
    else
      user = User.new(
        email: result['email'],
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
        render json: { user: user.as_json(methods: :image_path), result: result, token: encode_token({ id: user.id }) }, status: :ok
      else
        render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
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
      render json: { user: user.as_json(methods: :image_path), token: encode_token({ id: user.id }) }, status: :ok
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
        render json: { user: user.as_json(methods: :image_path), token: encode_token({ id: user.id }) }, status: :ok
      else
        render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

  def login_with_apple

    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    decoded = JWT.decode(access_token, nil, false)
    result = decoded.first
    return render json: {message: "Invalid token", decoded: decoded}, status: :unprocessable_entity if result.blank?

    user = MbcUser.where(login_type: "Apple").find_by(email: result["email"])
    
    if user.present?
      unless user.status == 'Active'
        render json: { message: 'Your account is inactive.' }, status: :unauthorized
        return
      end
      render json: { user: user.as_json(methods: :image_path), token: encode_token({ id: user.id }) }, status: :ok
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
        
        render json: { user: user.as_json(methods: :image_path), token: encode_token({ id: user.id }) }, status: :ok
      else
        render json: {message: "Failed to save the user", errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end

  end


  def register
    user = User.new(user_params)
    user.role = "Player"
    user.status = "Active"
    
    binding.pry
    
    if user.save 
      user.generate_verification_code
      if params[:image].present? 
        user.image = base64_to_file(params[:image])
        user.save
      end
      UserNotifierMailer.send_confirmation_email(user).deliver
      render json: {user: user.as_json(User.serializer), token: encode_token({ id: user.id }) }
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
        methods: %i[image_path],
        include: [],
        status: :ok
      )
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
    user = User.find_by(email: params[:email])
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
end
