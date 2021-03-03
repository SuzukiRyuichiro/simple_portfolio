class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products
    @total_valuation = @products.inject(0) {|result, product| result + calc_valuation(product) }
    authorize @user
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    quote_json = get_json(product)
    unless quote_json["Global Quote"].nil?
      # if the API does not return the quote, it would skip the price retrieval
      price = quote_json["Global Quote"]["05. price"].to_f
      total = 0.0
      product.purchases.each do |purchase|
        total += price * purchase.shares
      end
      return total
    end
  end

  def get_json(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    require 'open-uri'
    require 'json'

    url = open("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{product.ticker}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    puts JSON.parse(url)
    return JSON.parse(url)
  end
end
