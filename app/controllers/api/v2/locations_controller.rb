class Api::V2::LocationsController < Api::V2::ApiController
  include ImagesHelper
  def regions
    render json: Region.all
  end

  def provinces
    render json: Province.all.where(region_id: params[:region_id])
  end

  def cities
    render json: City.all.where(province_id: params[:province_id])
  end
end
