<<<<<<< HEAD

# Cryopto supported by AlphaVantage
=======
def percentage(json, index)
  all = json.count
  printf("\rComplete: %d%%", (index * 100 / all))
end
>>>>>>> master

current_dir = Dir.pwd
csv_options = { headers: :first_row }

# Products (cryptos) ----------------------------------------------------------------------------------------------------------------------

require 'csv'

puts "Crypto"
i = 0

CSV.foreach("#{current_dir}/db/crypto.csv", csv_options) do |row|
  product = Product.new(ticker: row['currency code'], name: row['currency name'])
  product.save
  percentage(CSV.read("#{current_dir}/db/crypto.csv"), i)
  i += 1
end

puts "Crypto complete"

# Products (stocks) ----------------------------------------------------------------------------------------------------------------------

require 'json'
require 'open-uri'

def finnhubStockSeeder(marketCode)
  accessToken = ENV["FINNHUB_API_KEY"]
  base_url = open("https://finnhub.io/api/v1/stock/symbol?exchange=#{marketCode}&token=#{accessToken}").read
  symbol_json = JSON.parse(base_url, {:symbolize_names => true})
  puts marketCode

  symbol_json.each_with_index do |row, index|
    product = Product.new(ticker: row[:displaySymbol], name: row[:description])
    product.save
    percentage(symbol_json, index)
  end

  puts "#{marketCode} complete"
end

# Actual seeding

['US', 'T', 'HK', 'L', 'SZ'].each do |code|
  finnhubStockSeeder(code)
end

# Platforms -----------------------------------------------------------------------------------------------------------------------------------

names = ["Robinhood", "Rakuten Securities", "LINE Securities", "BitFlyer", "Binance", "SBI Securities", "Kraken", "BITMAX", "kabu.com Securities", "Matsui Securities", "coinbase", "GMO Coin", "DMM Bitcoint"]

names.each do |platform|
  new_platform = Platform.new(name: platform)
  if new_platform.save
    print '>'
  end
end