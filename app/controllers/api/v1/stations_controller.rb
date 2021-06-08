class Api::V1::StationsController < Api::V1::ApiController
  before_action :require_user_login
  before_action :set_station, only: [:show, :update, :delete]
  include ImagesHelper

  def index
    render json: Station.all
  end

  def show
    render json: @station
  end

  def create
    @station = Station.new(station_params)

    if @station.save
      render json: @station
    else
      render json: @station.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if params[:image].present?
      @station.image = base64_to_file(params[:image]) 
    end
    if @station.update(station_params)

      if params[:image].present?
        @station.station_logo = rails_blob_path(@station.image)
        @station.save
      end
      render json: {station: @station, image: rails_blob_path(@station.image)}
    else
      render json: @station.errors.full_messages, status: :unprocessable_entity
    end
  end

  def delete
    @station.destroy
    render json: {message: "Station has successfully deleted"}
  end

  private
  def set_station
    @station = Station.find(params[:id])
  end

  def station_params
    params.require(:station).permit(
      :id,
      :date_created,
      :last_updated,
      :description,
      :frequency,
      :frequency_type,
      :image_folder,
      :name,
      :short_name,
      :station_logo,
      :station_logo_file_name,
      :status,
      :address_id,
      :covered_location_id,
    )
  end

end
