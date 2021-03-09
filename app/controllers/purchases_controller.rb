class PurchasesController < ApplicationController

  def new
    @purchase = Purchase.new
    authorize @purchase
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    authorize @purchase
    if @purchase.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def initial_bitflyer_connection
    @user = current_user
    @bitflyer_api_key = @user.bitflyer_api_key
    @bitflyer_api_secret = @user.bitflyer_api_secret
    get_past_orders_json_bitflyer.each do |order|
      purchase = Purchase.new(bitflyer_params)
      purchase.save
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:shares, :date, :price_at_purchase, :product_id, :platform_id)
  end

  def get_past_orders_bitflyer
    # this returns an array of hashes of past 100 orders. each array has
    # order date, order price, order size, and commision fee + alpha
    require "json"
    require "net/http"
    require "uri"
    require "openssl"

    key = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_SECRET']
    timestamp = Time.now.to_i.to_s
    method = "GET"
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = "/v1/me/getchildorders"
    uri.query = "product_code=BTC_JPY&count=100&before=0&after=0"

    text = timestamp + method + uri.request_uri
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

    options = Net::HTTP::Get.new(uri.request_uri, initheader = {
      "ACCESS-KEY" => key,
      "ACCESS-TIMESTAMP" => timestamp,
      "ACCESS-SIGN" => sign,
    });

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    return JSON.parse(response.body, symbolize_names: true)
  end

  def bitflyer_params
  # this method returns hash of information needed to create purchase


  return {
    platform_id: Platform.find_by(name: 'Bitflyer')
  }
  end
end
