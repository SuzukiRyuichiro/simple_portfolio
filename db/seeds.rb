# NASDAQ

current_dir = Dir.pwd

File.open("#{current_dir}/db/NASDAQ.txt").each do |line|
  info = line.split(" ", 2)
  product = Product.new(ticker: info[0].strip, name: info[1].strip)
  if product.save
    puts "#{product.name} is saved as #{product.ticker}"
  end
end
