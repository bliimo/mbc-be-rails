class Api::V2::AuthController < Api::V2::ApiController
  include ImagesHelper

  before_action :require_user_login, only: [:profile]

  def connection_test
    Rails.logger.debug "connection test action"
    Rails.logger.debug "Date #{DateTime.now.as_json}"
    Rails.logger.debug session_user.as_json
    render json: { message: 'yep its working' }, status: :ok
  end

  def login
    user = User.find_by(email: params[:email])
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

  def register
    user = User.new(user_params)
    user.role = "Player"
    user.status = "Active"
    if user.save 
      if params[:image].present? 
        user.image = base64_to_file(params[:image])
        user.save
      end
      render json: user.as_json(User.serializer)
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
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
    user = User.find_by(verification_code: params[:verification_code])
    if user.present?
      if user.code_expired?
        render json: { message: 'code expired' }, status: :unprocessable_entity
      else
        render json: { message: 'Code valid' }, status: :ok
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
      :name,
      :gender,
      :birthday,
      :country,
      :region_id,
      :province_id,
      :city_id
    )
  end

  def address_params
    params.require(:address).permit(
      :country,
      :province,
      :city,
      :barangay,
      :address_information,
      :postal_code
    )
  end

  def merchant_params
    params.require(:merchant).permit(
      :shop_name,
      :shop_description,
      :account_type
    )
  end

  def initialize_user
    user = User.new(user_params)
    user.status = 0
    user.generate_verification_code
    user
  end
end
