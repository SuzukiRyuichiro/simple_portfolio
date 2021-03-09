class Api::V1::ValuationsController < Api::V1::BaseController

  def fetch_total
    @user = current_user
    @products = @user.products
    render json: { valuation: @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product)}}
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    product.calculate_total_valuation_of_a_product(product.get_product_price)
  end
end
