class Api::V2::ProfileController < Api::V2::ApiController
  include ImagesHelper
  before_action :require_user_login

  def update_profile
    user = session_user
    
    if user.update(user_params)
      if params[:image].present? 
        user.image = base64_to_file(params[:image])
        user.save
      end
      render json: user.as_json(User.serializer)
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
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
