class BitFlyerOrderJob < ApplicationJob
  queue_as :default

  def perform(params, purchase_params)
    # Do something later
    bitflyer_order_api_request(params, purchase_params)
  end

  def bitflyer_order_api_request_body(params, purchase_params)
    hash = { product_code: "#{Product.find(purchase_params[:product_id]).ticker}_JPY",
             child_order_type: 'LIMIT',
             side: 'SELL',
             price: "#{purchase_params[:price_at_purchase]}",
             size: "#{purchase_params[:shares]}",
             minute_to_expire: "#{params[:minute_to_expire].to_i}",
             time_in_force: "#{params[:time_in_force]}"}
    hash.to_json
  end

  def bitflyer_order_api_request(params, purchase_params)
    require "net/http"
    require "uri"
    require "openssl"

    key = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_SECRET']

    timestamp = Time.now.to_i.to_s
    method = "POST"
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = "/v1/me/sendchildorder"
    body = bitflyer_order_api_request_body(params, purchase_params)

    text = timestamp + method + uri.request_uri + body
    sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

    options = Net::HTTP::Post.new(uri.request_uri, initheader = {
                                    "ACCESS-KEY" => key,
                                    "ACCESS-TIMESTAMP" => timestamp,
                                    "ACCESS-SIGN" => sign,
                                    "Content-Type" => "application/json"
    });
    options.body = body

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(options)
    puts response.body
  end
end