class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products.distinct
    @total_valuation = 0
    # @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product) }
#     @total_margin = calc_total_margin(@purchases)
    authorize @user
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    product.calculate_total_valuation_of_a_product(product.get_product_price)
  end

  def calc_total_margin(purchases)
    total_margin = 0
    purchases.each do |purchase|
      # calculate margin for each purchase that the user ever made
      total_margin += (purchase.product.get_product_price - purchase.price_at_purchase) * purchase.shares
    end
    return total_margin
  end
end
