class Api::V1::MobileReleasesController < Api::V1::ApiController
  before_action :set_mobile_release, only: %i[ show edit update destroy ]

  def index
    @page = params[:page] || 1
    @per = params[:per] || 10

    @mobile_releases = MobileRelease.all
    @count = @mobile_releases.count
    @mobile_releases = @mobile_releases.page(@page).per(@per)

    render json: {
      mobile_releases: @mobile_releases.as_json(), 
      types: {
        android_update_types: MobileRelease.android_update_types.keys,
        ios_update_types: MobileRelease.ios_update_types.keys
      },
      count: @count, 
      limit_value: @mobile_releases.limit_value,
      total_pages: @mobile_releases.total_pages,
      current_page: @mobile_releases.current_page,
      next_page: @mobile_releases.next_page,
      prev_page: @mobile_releases.prev_page,
    }
  end

  def check_for_updates
    render json: MobileRelease.all.last
  end

  def register_new_install
    @mobile_release = MobileRelease.find_by_build_code(params[:build_code])
    if @mobile_release.present?
      case params[:type]
      when "ios"
        count = @mobile_release.ios_number_of_installs || 0
        @mobile_release.ios_number_of_installs = count + 1
      when "android"
        count = @mobile_release.android_number_of_installs || 0
        @mobile_release.android_number_of_installs = count + 1
      else
        return render json: "Invalid type", status: :unprocessable_entity
      end
      @mobile_release.save
      render json: @mobile_release
    else
      render json: "Not Found", status: :not_found
    end

  end

  def show
    render json: @mobile_release
  end

  def create
    @mobile_release = MobileRelease.new(mobile_release_params)
    if @mobile_release.save
      render json: @mobile_release
    else
      render json: @mobile_release.errors, status: :unprocessable_entity
    end
  end

  def update
    if @mobile_release.update(mobile_release_params)
      render json: @mobile_release
    else
      render json: @mobile_release.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @mobile_release.destroy
    render json: {message: "Successfully Deleted"}
  end

  private

    def set_mobile_release
      @mobile_release = MobileRelease.find(params[:id])
    end


    def mobile_release_params
      # :android_number_of_installs 
      # :ios_number_of_installs
      params.require(:mobile_release).permit(:build_code, :android_update_type, :ios_update_type, :maintenance_mode)
    end
end
