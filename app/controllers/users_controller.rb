class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @purchase = Purchase.new
    @products = @user.products.distinct
    @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product) }
    # @product_valuation_pair = @products.map { |product| [product, calc_valuation(product)] }
    @product_price_pair = @products.map { |product| [product, product.get_product_price] }
    authorize @user
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    product.calculate_total_valuation_of_a_product(product.get_product_price)
  end
end
