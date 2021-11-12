class Api::V2::LocationsController < Api::V2::ApiController

  def regions
    render json: Region.all.order(name: :asc)
  end

  def provinces
    render json: Province.all.where(region_id: params[:region_id]).order(name: :asc)
  end

  def cities
    # render json: {message: "test"}
    render json: City.all.where(province_id: params[:province_id]).order(name: :asc), include: :province
  end
end
