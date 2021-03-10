class ChartsController < ApplicationController
  skip_after_action :verify_authorized, except: :index, unless: :skip_pundit?

  def valuation_history
    render json: current_user.valuations.pluck(:date, :total_valuation), xtitle: "Date", ytitle: "Valuation"
  end

  def stock_price_history
    @product = Product.find(params[:id])
    render json: @product.date_prices.first.pluck(:date, :price), xtitle: "Date", ytitle: "Valuation"
  end
end
