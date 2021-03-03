class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products

    @total_valuation = calc_valuation
    authorize @user
  end

  private

  def calc_valuation(product)
    # expects an instance of a product
    quote_json = get_json(product)
  end

  def get_json(product)
    # expects an instance of a product. It will call alpha vantage API to get the quote
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=#{product.ticker}&datatype=json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['RAPID_API_ALPHA_VANTAGE_KEY']
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

    response = http.request(request)
    return JSON.parse(response.read_body)
  end
end
