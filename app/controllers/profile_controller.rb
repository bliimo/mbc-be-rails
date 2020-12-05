class ProfileController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :set_navigation_name
  layout 'dashboard'

  def index; end

  def change_password; end

  def update_password
    if @user.valid_password?(params[:user][:current_password])
      respond_to do |format|
        if @user.update(user_params)
          sign_in :user, @user, bypass: true
          format.html { redirect_to '/profile', notice: 'Password was successfully updated.' }
        else
          format.html { render :change_password }
        end
      end
    else
      @user.errors.add(:current_password, ' is not correct')
      respond_to do |format|
        format.html { render :change_password }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end

  def set_navigation_name
    @navigation_name = 'Profile'
  end
end
