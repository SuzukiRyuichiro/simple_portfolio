# Cryopto supported by AlphaVantage
require 'csv'

CSV.foreach("#{current_dir}/db/crypto.csv", csv_options) do |row|
  product = Product.new(ticker: row['currency code'], name: row['currency name'])
  if product.save
    puts "#{product.ticker} : #{product.name}"
  end
end

puts "Crypto complete. Products count: #{Product.count}"

require 'json'
require 'open-uri'

def finnhubStockSeeder(marketCode)
  accessToken = ENV["FINNHUB_API_KEY"]
  base_url = open("https://finnhub.io/api/v1/stock/symbol?exchange=#{marketCode}&token=#{accessToken}").read
  symbol_json = JSON.parse(base_url, {:symbolize_names => true})

  symbol_json.each do |row|
    product = Product.new(ticker: row[:displaySymbol], name: row[:description])
    if product.save
      puts "#{product.ticker} : #{product.name}"
    end
  end
end

# Actual seeding

['US', 'T', 'HK', 'L', 'SZ'].each do |code|
  finnhubStockSeeder(code)
end



