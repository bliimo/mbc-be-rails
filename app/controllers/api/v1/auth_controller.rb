class Api::V1::AuthController < Api::V1::ApiController
  def connection_test
    NotificationChannel.broadcast_to(
      "all",
      { message: "notification channel first broadcast" }
    )
    render json: { message: 'yep its working' }, status: :ok
  end

  def broadcast_logout
    UserStatusChannel.broadcast_to(
      MbcUser.find(params[:id]),
      { type: "LOGOUT"}
    )
  end

  def tokens
    render json: Token.where(user_id: params[:id])
  end 

  def login
    user = MbcUser.find_by(email: params[:email])
    if user.present? && user.valid_password?(params[:password])
      tokens = Token.where(user_id: user.id)
      if tokens.count > 0
        return render json: {message: 'User was already logged in in another device', tokens: tokens}, status: :unauthorized
      end

      if user.user_status != 3
        verification = Verification.where(email: params[:email]).last
        if verification.blank?
          verification = Verification.create(
            code:   (SecureRandom.random_number(9e5) + 1e5).to_i.to_s,
            email:  user.email,
            email_status:  "SENT",
            user_id:  user.id
          )
        end
        UserNotifierMailer.send_confirmation_email(user, verification).deliver
        return render json: {message: "Your account is not verified. Please go to your email to verify.", code: 400}, status: 400
      end

      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
      }
      render json: response, status: :ok
    else
      render json: { message: 'Log in failed! Invalid email or password.' }, status: :unauthorized
    end
  end

  def login_with_facebook
    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    result = JSON.parse Net::HTTP.get(URI.parse("https://graph.facebook.com/me?fields=id,name,first_name,last_name,email,picture.type(large)&access_token=#{access_token}"))
    return render json: {message: "Invalid access key", fb_response: result}, status: :unprocessable_entity if result["error"].present?
    user = nil
    if(result["email"])
      user = MbcUser.find_by(email: result["email"])
    else
      user = MbcUser.find_by(id: result["id"])
    end
    if user.present?
      tokens = Token.where(user_id: user.id)
      if tokens.count > 0
        return render json: {message: 'User was already logged in in another device', tokens: tokens}, status: :unauthorized
      end
      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        result: result
      }
      render json: response, status: :ok
    else
      address = Address.create(
        dtype: "address",
        date_created: DateTime.now,
        last_updated: DateTime.now,
        country: "Philippines",
        city_municipality_id_fk: 1,
        province_id_fk: 1,
        region_id_fk: 1
      )
      user = MbcUser.new(
        :id => result["id"],
        :user_type => "audience",
        :date_created => DateTime.now,
        :last_updated => DateTime.now,
        :birth_date => nil,
        :email => result["email"] || "testemail#{DateTime.now.to_i.to_s}@mbc.com",
        :full_name => "#{result["first_name"]}@@#{result["last_name"]}",
        :gender => "UNDISCLOSED",
        :mobile_number => nil,
        :user_status => 3,
        :username => nil,
        :screen_name => "testagain",
        :address_id => address.id,
        :radio_station_id_fk => 1,
        :password => DateTime.now.to_i.to_s
      )
      user.save
      UserRole.create(user_id: user.id, role_id: 4)
      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        result: result
      }
      render json: response, status: :ok
    end
  end

  def login_with_google
    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    
    decoded = JWT.decode(access_token, nil, false)
    response = decoded.first

    return render json: {message: "Invalid token", decoded: decoded}, status: :unprocessable_entity if response.blank?
    user = MbcUser.find_by(email: response["email"])
    if user.present?
      tokens = Token.where(user_id: user.id)
      if tokens.count > 0
        return render json: {message: 'User was already logged in in another device', tokens: tokens}, status: :unauthorized
      end
      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        response: response
      }
      render json: response, status: :ok
    else
      address = Address.create(
        dtype: "address",
        date_created: DateTime.now,
        last_updated: DateTime.now,
        country: "Philippines",
        city_municipality_id_fk: 1,
        province_id_fk: 1,
        region_id_fk: 1
      )
      user = MbcUser.new(
        :user_type => "audience",
        :date_created => DateTime.now,
        :last_updated => DateTime.now,
        :birth_date => nil,
        :email => response["email"] || "testemail#{DateTime.now.to_i.to_s}@mbc.com",
        :full_name => "#{response["first_name"]}@@#{response["last_name"]}",
        :gender => "UNDISCLOSED",
        :mobile_number => nil,
        :user_status => 3,
        :username => nil,
        :screen_name => "testagain",
        :address_id => address.id,
        :radio_station_id_fk => 1,
        :password => DateTime.now.to_i.to_s
      )
      user.save
      UserRole.create(user_id: user.id, role_id: 4)
      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        response: response
      }
      render json: response, status: :ok
    end
  end

  def login_with_apple

    access_token = params[:access_token]
    return render json: {error: {message: "Access token is required"}} if access_token.blank?
    
    decoded = JWT.decode(access_token, nil, false)
    response = decoded.first

    return render json: {message: "Invalid token", decoded: decoded}, status: :unprocessable_entity if response.blank?

    user = MbcUser.find_by(email: response["email"])
    if user.present?
      tokens = Token.where(user_id: user.id)
      if tokens.count > 0
        return render json: {message: 'User was already logged in in another device', tokens: tokens}, status: :unauthorized
      end
      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        response: response
      }
      render json: response, status: :ok
    else
      address = Address.create(
        dtype: "address",
        date_created: DateTime.now,
        last_updated: DateTime.now,
        country: "Philippines",
        city_municipality_id_fk: 1,
        province_id_fk: 1,
        region_id_fk: 1
      )
      user = MbcUser.new(
        :user_type => "audience",
        :date_created => DateTime.now,
        :last_updated => DateTime.now,
        :birth_date => nil,
        :email => response["email"] || "testemail#{DateTime.now.to_i.to_s}@mbc.com",
        :full_name => "#{params["first_name"]}@@#{params["last_name"]}",
        :gender => "UNDISCLOSED",
        :mobile_number => nil,
        :user_status => 3,
        :username => nil,
        :screen_name => "testagain",
        :address_id => address.id,
        :radio_station_id_fk => 1,
        :password => DateTime.now.to_i.to_s
      )
      user.save
      UserRole.create(user_id: user.id, role_id: 4)

      response = {
        accessToken: encode_token(user.id),
        tokenType: "Bearer",
        userType: user.user_type,
        user: user,
        response: response
      }
      render json: response, status: :ok
    end

  end

  def register_user
    user = initialize_user
    user.role = 2

    address = Address.new(address_params)

    unless user.valid?
      render json: user.errors.full_messages, status: :unprocessable_entity
      return
    end

    unless address.valid?
      render json: address.errors.full_messages, status: :unprocessable_entity
      return
    end

    user.save
    address.save

    buyer = Buyer.new
    buyer.user = user
    buyer.save

    billing_address = BillingAddress.create(
      buyer_id: buyer.id,
      contact_name: user.name,
      contact_number: user.contact_number,
      label: 'HOME',
      address_id: address.id
    )
    UserNotifierMailer.send_verification_code(user, request).deliver
    render json: {
      user: user,
      buyer: buyer,
      billing_address: billing_address,
      address: address,
      token: encode_token({ id: user.id })
    }, status: :ok
  end

  def register_playmate
    user = initialize_user
    user.role = 3

    unless user.valid?
      render json: user.errors.full_messages, status: :unprocessable_entity
      return
    end

    user.save

    playmate = Playmate.new
    playmate.user = user
    playmate.save

    UserNotifierMailer.send_verification_code(user, request).deliver
    render json: {
      user: user,
      playmate: playmate,
      token: encode_token({ id: user.id })
    }, status: :ok
  end

  def register_as_merchant
    user = initialize_user
    user.role = 1

    unless user.valid?
      render json: user.errors.full_messages, status: :unprocessable_entity
      return
    end

    address = Address.new(address_params)
    unless address.valid?
      render json: address.errors.full_messages, status: :unprocessable_entity
      return
    end

    merchant = Merchant.new(merchant_params)
    merchant.user = user
    merchant.address = address
    merchant.status = 'Active'
    merchant.approval_status = 'Pending'
    unless merchant.valid?
      render json: merchant.errors.full_messages, status: :unprocessable_entity
      return
    end

    user.save
    address.save
    merchant.save
    UserNotifierMailer.send_confirmation_email(user, request).deliver

    render json: {
      user: user,
      address: address,
      merchant: merchant,
      token: encode_token({ id: user.id })
    }, status: :ok
  end

  def profile
    if session_buyer.present?
      render(
        json: session_buyer,
        methods: %i[image_path total_in_app_currency],
        include: [
          {
            buyer: {
              include: [
                {
                  billing_addresses: {
                    include: [
                      :address
                    ]
                  }
                }
              ]
            }
          }
        ],
        status: :ok
      )
    elsif session_merchant.present?
      render(
        json: session_merchant,
        methods: [:image_path],
        include: [merchant: { include: [:address], methods: %i[profile_picture_path banners_path] }],
        status: :ok
      )
    elsif session_playmate.present?
      render(
        json: session_playmate,
        methods: [:image_path],
        include: [:playmate],
        status: :ok
      )
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
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

  def send_confirmation_email
    user = MbcUser.find_by(email: params[:email])
    return render json: {error: {message: 'user not found'}}, status: 404 if user.blank?

    verification = Verification.where(email: params[:email]).last
    if verification.blank?
      verification = Verification.create(
        code:   (SecureRandom.random_number(9e5) + 1e5).to_i.to_s,
        email:  user.email,
        email_status:  "SENT",
        user_id:  user.id
      )
    end
    UserNotifierMailer.send_confirmation_email(user, verification).deliver
    render json: {message: "Email sent successfully"}
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
      :password,
      :password_confirmation
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
