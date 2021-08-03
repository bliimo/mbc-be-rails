class Api::V2::NetworksController < Api::V2::ApiController
  before_action :require_user_login

  def index
    render json: Network.all.as_json(Network.serializer)
  end
end
