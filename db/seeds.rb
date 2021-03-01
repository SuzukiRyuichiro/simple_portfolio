# NASDAQ

current_dir = Dir.pwd

File.open("#{current_dir}/db/NASDAQ.txt").each do |line|
  info = line.split(" ", 2)
  product = Product.new(ticker: info[0].strip, name: info[1].strip)
  if product.save
    print '>'
  end
end

puts "NASDAQ complete. Products count: #{Product.count}"

# NYSE

require 'csv'

csv_options = {headers: :first_row}

CSV.foreach("#{current_dir}/db/nyse.csv", csv_options) do |row|
  product = Product.new(ticker: row['Symbol'], name: row['Name'])
  if product.save
    print '>'
  end
end

puts "NYSE complete. Products count: #{Product.count}"
