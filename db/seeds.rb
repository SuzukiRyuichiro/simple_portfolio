# NASDAQ

current_dir = Dir.pwd

File.open("#{current_dir}/db/NASDAQ.txt").each do |line|
  info = line.split(" ", 2)
  product = Product.new(ticker: info[0].strip, name: info[1].strip)
  if product.save
    puts "#{product.ticker} : #{product.name}"
  end
end

puts "NASDAQ complete. Products count: #{Product.count}"

# NYSE

require 'csv'

csv_options = {headers: :first_row}

CSV.foreach("#{current_dir}/db/nyse.csv", csv_options) do |row|
  product = Product.new(ticker: row['Symbol'], name: row['Name'])
  if product.save
    puts "#{product.ticker} : #{product.name}"
  end
end

puts "NYSE complete. Products count: #{Product.count}"

# Cryopto supported by AlphaVantage

CSV.foreach("#{current_dir}/db/crypto.csv", csv_options) do |row|
  product = Product.new(ticker: row['currency code'], name: row['currency name'])
  if product.save
    puts "#{product.ticker} : #{product.name}"
  end
end

puts "Crypto complete. Products count: #{Product.count}"

# TSE

require 'roo'
require 'roo-xls'

spreadsheet = Roo::Spreadsheet.open("#{current_dir}/db/data_e.xls", extension: :xls)

spreadsheet.sheet(0).each do |row|
  product = Product.new(ticker: row[1].to_i, name: row[2])
  if product.save
    puts "#{product.ticker} : #{product.name}"
  end
end

