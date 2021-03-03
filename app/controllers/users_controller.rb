require 'open-uri'
require 'json'

class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products
    @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product) }
    @products_valuation_pair = @products.map { |product| [product, calc_valuation(product)] }
    authorize @user
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    if product.kind == 'Stock'
      quote_json = get_stock_json(product)
      unless quote_json["Global Quote"].nil?
        # if the API does not return the quote, it would skip the price retrieval
        price = quote_json["Global Quote"]["05. price"].to_f
        calculate_total_valuation_of_a_prodcut(product, price)
      end
    elsif product.kind == 'Crypto'
      quote_json = get_crypto_json(product)
      unless quote_json["Realtime Currency Exchange Rate"].nil?
        price = quote_json["Realtime Currency Exchange Rate"]["5. Exchange Rate"].to_f
        calculate_total_valuation_of_a_prodcut(product, price)
      end
    end
  end

  def get_stock_json(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{product.ticker}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    puts JSON.parse(url)
    return JSON.parse(url)
  end

  def get_crypto_json(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=#{product.ticker}&to_currency=#{product.currency}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    puts JSON.parse(url)
    return JSON.parse(url)
  end

  def calculate_total_valuation_of_a_prodcut(product, price)
    total = 0.0
    product.purchases.each do |purchase|
      total += price * purchase.shares
    end
    return total
  end
end
