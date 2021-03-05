class ChartsController < ApplicationController
  skip_after_action :verify_authorized, except: :index, unless: :skip_pundit?

  def valuation_history
    render json: current_user.valuations.pluck(:date, :total_valuation), xtitle: "Date", ytitle: "Valuation"
  end
end
