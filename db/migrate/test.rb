require 'uri'
require 'net/http'

uri = URI("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest")

params = { :symbol => 'BTC', :CMC_PRO_API_KEY => ENV['COIN_MARKET_CAP_API_KEY'] }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts res.body if res.is_a?(Net::HTTPSuccess)
