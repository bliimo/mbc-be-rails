class MobileReleasesController < ApplicationController
  before_action :set_mobile_release, only: %i[ show edit update destroy ]

  # GET /mobile_releases or /mobile_releases.json
  def index
    @mobile_releases = MobileRelease.all
  end

  # GET /mobile_releases/1 or /mobile_releases/1.json
  def show
  end

  # GET /mobile_releases/new
  def new
    @mobile_release = MobileRelease.new
  end

  # GET /mobile_releases/1/edit
  def edit
  end

  # POST /mobile_releases or /mobile_releases.json
  def create
    @mobile_release = MobileRelease.new(mobile_release_params)

    respond_to do |format|
      if @mobile_release.save
        format.html { redirect_to @mobile_release, notice: "Mobile release was successfully created." }
        format.json { render :show, status: :created, location: @mobile_release }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mobile_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mobile_releases/1 or /mobile_releases/1.json
  def update
    respond_to do |format|
      if @mobile_release.update(mobile_release_params)
        format.html { redirect_to @mobile_release, notice: "Mobile release was successfully updated." }
        format.json { render :show, status: :ok, location: @mobile_release }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mobile_release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mobile_releases/1 or /mobile_releases/1.json
  def destroy
    @mobile_release.destroy
    respond_to do |format|
      format.html { redirect_to mobile_releases_url, notice: "Mobile release was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobile_release
      @mobile_release = MobileRelease.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mobile_release_params
      params.require(:mobile_release).permit(:build_code, :android_update_type, :ios_update_type, :android_number_of_installs, :ios_number_of_installs, :maintenance_mode)
    end
end
