class PurchasesController < ApplicationController

  def new
    @purchase = Purchase.new
    authorize @purchase
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    authorize @purchase
    if params[:api_order].nil?
      if @purchase.save
        redirect_to product_path(@purchase.product)
      else
        # render :new this needs fix
      end
    else
      bitflyer_order_api_request
      if @purchase.save
        redirect_to product_path(@purchase.product)
      end
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:shares, :date, :price_at_purchase, :product_id, :platform_id)
  end

  def bitflyer_order_api_request_body
    hash = { product_code: "#{Product.find(purchase_params[:product_id]).ticker}_JPY",
      child_order_type: 'LIMIT',
      side: 'SELL',
      price: "#{purchase_params[:price_at_purchase]}",
      size: "#{purchase_params[:shares]}",
      minute_to_expire: "#{params[:minute_to_expire].to_i}",
      time_in_force: "#{params[:time_in_force]}"}
    render :json => hash
  end

  def bitflyer_order_api_request
    require "net/http"
    require "uri"
    require "openssl"

    key = ENV['BITFLYER_API_KEY']
    secret = ENV['BITFLYER_API_SECRET']

    timestamp = Time.now.to_i.to_s
    method = "POST"
    uri = URI.parse("https://api.bitflyer.com")
    uri.path = "/v1/me/sendchildorder"
    body = bitflyer_order_api_request_body

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
