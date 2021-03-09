class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :purchases
  has_many :valuations
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :products, through: :purchases
  has_many :platforms, through: :purchases

  after_update :initial_bitflyer_connection

  def initial_bitflyer_connection
    puts "its in"
    if :saved_change_to_bitflyer_api_key? || :saved_change_to_bitflyer_api_secret?
      puts "its in the if statement"
      get_past_orders_bitflyer.each do |order|
        purchase = Purchase.new(bitflyer_params(order))
        puts "saved" if purchase.save
      end
    end
  end

  private

  def bitflyer_params(order)
    # expects a single hash from bitflyer API response
    # this method returns hash of information needed to create purchase
    return {
      user: self,
      shares: order[:size],
      date: DateTime.parse(order[:child_order_date]),
      price_at_purchase: order[:average_price],
      product: Product.find_by(ticker: 'BTC'),
      platform: Platform.find_by(name: 'bitFlyer')
    }
  end

  def get_past_orders_bitflyer
    # this returns an array of hashes of past 100 orders. each array has
    # order date, order price, order size, and commision fee + alpha
    require "json"
    require "net/http"
    require "uri"
    require "openssl"

    key = ENV['BITFLYER_API_KEY']
    # key = bitflyer_api_key
    secret = ENV['BITFLYER_API_SECRET']
    # secret = bitflyer_api_secret
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
end
