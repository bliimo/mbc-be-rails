class EmailHandlerController < ApplicationController
  def confirm_email
    @user = User.find_by(confirmation_token: params[:token])
    @user.verified_at = Date.today
    @user.save(validate: false)
  end
end




