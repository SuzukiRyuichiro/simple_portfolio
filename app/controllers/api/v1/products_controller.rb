class Api::V1::ProductsController < Api::V1::BaseController
  def search
    if params[:query]
      @products = Product.search_by_name_and_ticker(params[:query]).first(5)
      render json: @products.map do |product|
        {
          name: product.name,
          ticker: product.ticker,
          id: product.id,
        }
      end
    end
  end
end