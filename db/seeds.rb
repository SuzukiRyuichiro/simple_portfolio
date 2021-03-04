# Fancy loading stuff -----------------------------------------------------------------------------------------------------------------------------------

def percentage(json, index)
  all = json.count
  printf("\rComplete: %d%%", (index * 100 / all))
end

# setting variables for seeging ---------------------------------------------------------------------------------------------------------------

current_dir = Dir.pwd
csv_options = { headers: :first_row }

# Test User -----------------------------------------------------------------------------------------------------------------------------------

test_user = User.new(email: "mail@mail.com", password: "123123")
if test_user.save
  puts "test user was created. email: #{test_user.email}, password: 123123"
end

# Products (cryptos) ----------------------------------------------------------------------------------------------------------------------

# require 'csv'

# puts "Crypto"
# i = 0

# CSV.foreach("#{current_dir}/db/crypto.csv", csv_options) do |row|
#   product = Product.new(ticker: row['currency code'], name: row['currency name'])
#   product.save
#   percentage(CSV.read("#{current_dir}/db/crypto.csv"), i)
#   i += 1
# end

# puts "Crypto complete"

# Products (short version) ----------------------------------------------------------------------------------------------------------------------
require 'json'
require 'open-uri'

accessToken = ENV["FINNHUB_API_KEY"]

['AAPL', 'tesla', 'gamestop'].each do |company|
  base_url = open("https://finnhub.io/api/v1/search?q=#{company}&token=#{accessToken}").read
  json = JSON.parse(base_url, {:symbolize_names => true})
  product = Product.new(name: json[:result][0][:description], ticker: json[:result][0][:displaySymbol], currency: "USD", kind: "Stock")
  product.save
end

[{name: 'Bitcoin', ticker: 'BTC'}, {name: 'Etherium', ticker: 'ETH'}].each do |crypto|
  product = Product.new(name: crypto[:name], ticker: crypto[:ticker], currency: "USD", kind: 'Crypto')
  product.save
end


# Products (stocks) ----------------------------------------------------------------------------------------------------------------------

# require 'json'
# require 'open-uri'

# def finnhubStockSeeder(marketCode)
#   accessToken = ENV["FINNHUB_API_KEY"]
#   base_url = open("https://finnhub.io/api/v1/stock/symbol?exchange=#{marketCode}&token=#{accessToken}").read
#   symbol_json = JSON.parse(base_url, {:symbolize_names => true})
#   puts marketCode

#   symbol_json.each_with_index do |row, index|
#     product = Product.new(ticker: row[:displaySymbol], name: row[:description])
#     product.save
#     percentage(symbol_json, index)
#   end

#   puts "#{marketCode} complete"
# end

# # Actual seeding

# ['US', 'T', 'HK', 'L', 'SZ'].each do |code|
#   finnhubStockSeeder(code)
# end

# Platforms -----------------------------------------------------------------------------------------------------------------------------------

names = ["Robinhood", "Rakuten Securities", "LINE Securities", "BitFlyer", "Binance", "SBI Securities", "Kraken", "BITMAX", "kabu.com Securities", "Matsui Securities", "coinbase", "GMO Coin", "DMM Bitcoint"]

names.each do |platform|
  new_platform = Platform.new(name: platform)
  if new_platform.save
    print '>'
  end
end

# Purchsaes -----------------------------------------------------------------------------------------------------------------------------------

test_stocks = ['AAPL', 'TSLA', 'BTC', 'GME', 'ETH']

test_stocks.each do |stock|
  new_purchase = Purchase.new(
    date: rand(5.days).seconds.ago,
    shares: (1..10).to_a.sample,
    product: Product.find_by(ticker: stock),
    user: test_user,
    platform: Platform.all.sample,
    price_at_purchase: 100.0)
  if new_purchase.save
    puts "#{test_user.email} bought #{new_purchase.shares} shares of #{new_purchase.product.name} on #{new_purchase.date}"
  end
end

# Valuations -----------------------------------------------------------------------------------------------------------------------------------

date = Time.now - 10.days.seconds

10.times do
  new_valuation = Valuation.new(user: test_user, date: date, total_valuation: 13000 + rand(-1000..1000))
  if new_valuation.save
    puts "On #{new_valuation.date}, #{test_user.email} had total valuation of #{new_valuation.total_valuation}"
end
