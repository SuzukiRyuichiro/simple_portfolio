require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @purchase = Purchase.new
    @products = @user.products
    @products = @user.products.uniq
    @total_valuation = @products.inject(0) { |result, product| result + calc_valuation(product) }
    # @product_valuation_pair = @products.map { |product| [product, calc_valuation(product)] }
    @product_price_pair = @products.map { |product| [product, get_product_price(product)] }
    authorize @user
  end

  private

  def get_product_price(product)
    if product.kind == 'Stock'
      if product.currency == 'USD'
        get_stock_price_from_json_fh(product)
      else
        get_stock_price_from_json_av(product)
      end
    elsif product.kind == 'Crypto'
      get_crypto_price_from_json_cmc(product)
    end
  end

  def calc_valuation(product)
    # expects an instance of a product
    calculate_total_valuation_of_a_product(product, get_product_price(product))
  end

  def get_stock_json_av(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{product.ticker}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_stock_json_fh(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://finnhub.io/api/v1/quote?symbol=#{product.ticker}&token=#{ENV['FINNHUB_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_crypto_json_av(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=#{product.ticker}&to_currency=#{product.currency}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_crypto_json_cmc(product)
    uri = URI("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest")
    params = { :symbol => product.ticker, :CMC_PRO_API_KEY => ENV['COIN_MARKET_CAP_API_KEY'] }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end

  def calculate_total_valuation_of_a_product(product, price)
    total = 0.0
    unless price.nil?
      product.purchases.each do |purchase|
        total += price * purchase.shares
      end
    end
    return total
  end

  def get_stock_price_from_json_fh(product)
    quote_json = get_stock_json_fh(product)
    unless quote_json["c"].zero?
      # if the API does not return the quote, it would skip the price retrieval
      price = quote_json["c"].to_f
      return price
    else
      return 0
    end
  end

  def get_stock_price_from_json_av(product)
    quote_json = get_stock_json_av(product)
    unless quote_json["Global Quote"].nil?
      # if the API does not return the quote, it would skip the price retrieval
      price = quote_json["Global Quote"]["05. price"].to_f
      return price
    else
      return 0
    end
  end

  def get_crypto_price_from_json_av(product)
    quote_json = get_crypto_json_av(product)
    unless quote_json["Realtime Currency Exchange Rate"].nil?
      price = quote_json["Realtime Currency Exchange Rate"]["5. Exchange Rate"].to_f
      return price
    else
      return 0
    end
  end

  def get_crypto_price_from_json_cmc(product)
    quote_json = get_crypto_json_cmc(product)
    unless quote_json["status"]["error_code"] == 400
      price = quote_json["data"][product.ticker]["quote"]["USD"]["price"].to_f
      return price
    else
      return 0
    end
  end
end
