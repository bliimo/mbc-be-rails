class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_navigation_name
  layout 'dashboard'

  def index; end

  private

  def set_navigation_name
    @navigation_name = 'Dashboard'
  end
end
