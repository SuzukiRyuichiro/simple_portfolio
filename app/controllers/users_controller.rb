class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products.distinct

    @finnhub_articles = finnhub_news.sample(10)

    # @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product) }
    # @total_margin = calc_total_margin(@purchases)
    authorize @user
  end

  def connect_to_bitflyer
    @user = current_user
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    @user.update(user_params)
    redirect_to dashboard_path
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

  def user_params
    params.require(:user).permit(:bitflyer_api_key, :bitflyer_api_secret)
  end

  def finnhub_news
    require 'open-uri'
    require 'json'
    json = open("https://finnhub.io/api/v1/news?category=general&token=#{ENV['FINNHUB_API_KEY']}").read
    return JSON.parse(json, symbolize_names: true)
  end
end
