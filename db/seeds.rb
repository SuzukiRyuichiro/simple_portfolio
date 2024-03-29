puts "Seeding......"

DatePrice.destroy_all
Purchase.destroy_all
Product.destroy_all
Platform.destroy_all
Valuation.destroy_all
User.destroy_all

# Fancy loading stuff -----------------------------------------------------------------------------------------------------------------------------------

def percentage(json, index)
  all = json.count
  printf("\rComplete: %d%%", (index * 100 / all))
end

# setting variables for seeging ---------------------------------------------------------------------------------------------------------------

current_dir = Dir.pwd
csv_options = { headers: :first_row }

# Test User -----------------------------------------------------------------------------------------------------------------------------------

test_user = User.new(email: "mail@mail.com", password: "123123", admin: true)
if test_user.save
  puts "test user was created. email: #{test_user.email}, password: 123123"
end

# Products (cryptos) ----------------------------------------------------------------------------------------------------------------------

require 'csv'

puts "Crypto"
i = 0

CSV.foreach("#{current_dir}/db/crypto.csv", csv_options) do |row|
  product = Product.new(ticker: row['currency code'], name: row['currency name'], currency: "USD", kind: 'Crypto')
  product.save
  percentage(CSV.read("#{current_dir}/db/crypto.csv"), i)
  i += 1
end

puts "Crypto complete"

# Products (short version) ----------------------------------------------------------------------------------------------------------------------
# require 'json'
# require 'open-uri'

# accessToken = ENV["FINNHUB_API_KEY"]

# ['AAPL', 'TSLA', 'gamestop'].each do |company|
#   base_url = open("https://finnhub.io/api/v1/search?q=#{company}&token=#{accessToken}").read
#   json = JSON.parse(base_url, {:symbolize_names => true})
#   product = Product.new(name: json[:result][0][:description], ticker: json[:result][0][:displaySymbol], currency: "USD", kind: "Stock")
#   product.save
# end


[{name: 'Bitcoin', ticker: 'BTC', finnhub_symbol: 'BINANCE:BTCUSDT'}, {name: 'Etherium', ticker: 'ETH', finnhub_symbol: 'BINANCE:ETHUSDT'}, {name: 'Bitcoin Cash', ticker: 'BCH', finnhub_symbol: 'BINANCE:BCHUSDT'}].each do |crypto|
  product = Product.new(name: crypto[:name], ticker: crypto[:ticker], currency: "USD", kind: 'Crypto', finnhub_symbol: crypto[:finnhub_symbol])
  product.save
end



# Products (stocks) ----------------------------------------------------------------------------------------------------------------------

require 'json'
require 'open-uri'

def finnhubStockSeeder(marketCodeAndMic)
  accessToken = ENV["FINNHUB_API_KEY"]
  base_url = open("https://finnhub.io/api/v1/stock/symbol?exchange=#{marketCodeAndMic[:marketCode]}&mic=#{marketCodeAndMic[:mic]}&token=#{accessToken}").read
  symbol_json = JSON.parse(base_url, {:symbolize_names => true})
  # puts "#{marketCodeAndMic[:marketCode]}, #{marketCodeAndMic[:mic]}"
  symbol_json.each_with_index do |row, index|
    product = Product.new(ticker: row[:displaySymbol], name: row[:description], currency: "USD", kind: "Stock")
    puts "#{product.name&.capitalize} saved" if product.save
    # percentage(symbol_json, index)
  end

  puts "#{marketCodeAndMic[:mic]} complete"
end

# Actual seeding

[{marketCode: 'US', mic: 'XNYS'}, {marketCode: 'US', mic: 'XNAS'}].each do |marketCodeAndMic|
  finnhubStockSeeder(marketCodeAndMic)
end

# Platforms -----------------------------------------------------------------------------------------------------------------------------------

names = ["Robinhood", "Rakuten Securities", "LINE Securities", "bitFlyer", "Binance", "SBI Securities", "Kraken", "BITMAX", "kabu.com Securities", "Matsui Securities", "coinbase", "GMO Coin", "DMM Bitcoint"]

names.each do |platform|
  new_platform = Platform.new(name: platform)
  if new_platform.save
    print '>'
  end
end

# Purchsaes -----------------------------------------------------------------------------------------------------------------------------------

test_stocks = ['AAPL', 'TSLA', 'BTC', 'BCH', 'GOOGL', 'AMD', 'BA', 'PFE']

test_stocks.each do |stock|
  new_purchase = Purchase.new(
    date: rand(5.days).seconds.ago,
    product: Product.find_by(ticker: stock),
    shares: Product.find_by(ticker: stock).kind == 'Crypto' ? rand(0..0.3).round(2) : (1..10).to_a.sample,
    user: test_user,
    platform: Platform.all.sample,
    price_at_purchase: (Product.find_by(ticker: stock).get_product_price + rand(-10..10)).round(2) || 10.0 )
  if new_purchase.save
    puts "#{test_user.email} bought #{new_purchase.shares} shares of #{new_purchase.product.name} at #{new_purchase.price_at_purchase}"
  end
end

# Valuations -----------------------------------------------------------------------------------------------------------------------------------

date = Time.now - 10.days.seconds

10.times do
  new_valuation = Valuation.new(user: test_user, date: date, total_valuation: 13000 + rand(-1000..1000))
  if new_valuation.save
    puts "On #{new_valuation.date}, #{test_user.email} had total valuation of #{new_valuation.total_valuation}"
    date += 1.days.seconds
  end
end

# Date_Price -----------------------------------------------------------------------------------------------------------------------------------
test_stocks = ['AAPL', 'TSLA', 'GME']

# from local files
test_stocks.each do |stock|
  file = File.read("#{current_dir}/db/sample jsons/#{stock} daily.json")
  json = JSON.parse(file)
  json["Time Series (Daily)"].each do |arr|
    components = arr[0].split('-')
    year = components[0].to_i
    month = components[1].to_i
    day = components[2].to_i
    date_price = DatePrice.new(date: DateTime.new(year, month, day), price: arr[1]["4. close"].to_f, product: Product.find_by(ticker: stock))
    if date_price.save
      # puts "#{date_price.product.ticker} was #{date_price.price} on #{date_price.date}"
    end
  end
end

test_stocks = ['AMD', 'GOOGL', 'BA', 'PFE']

test_stocks.each do |stock|
  file = open("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{stock}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
  json = JSON.parse(file)
  json["Time Series (Daily)"].each do |arr|
    components = arr[0].split('-')
    year = components[0].to_i
    month = components[1].to_i
    day = components[2].to_i
    date_price = DatePrice.new(date: DateTime.new(year, month, day), price: arr[1]["4. close"].to_f, product: Product.find_by(ticker: stock))
    if date_price.save
      puts "#{date_price.product.ticker} was #{date_price.price} on #{date_price.date}"
    end
  end
end

# from API

test_cryptos = ['BTC', 'ETH', 'BCH']

test_cryptos.each do |crypto|
  file = File.read("#{current_dir}/db/sample jsons/#{crypto} daily.json")
  json = JSON.parse(file)
  json["Time Series (Digital Currency Daily)"].each do |arr|
    components = arr[0].split('-')
    year = components[0].to_i
    month = components[1].to_i
    day = components[2].to_i
    date_price = DatePrice.new(date: DateTime.new(year, month, day), price: arr[1]["4a. close (USD)"].to_f, product: Product.find_by(ticker: crypto))
    if date_price.save
      # puts "#{date_price.product.ticker} was #{date_price.price} on #{date_price.date}"
    end
  end
end
