class Api::V1::ValuationsController < Api::V1::BaseController

  def fetch_total
    @user = current_user
    render json: {  }
  end
end
