class Product < ApplicationRecord
  require 'open-uri'
  require 'json'
  require 'uri'
  require 'net/http'

  has_many :purchases
  has_many :date_prices
  has_many :platforms, through: :purchases
  validates :name, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name_and_ticker,
    against: [ :name, :ticker ],
    # associated_against: {
    #   user: :email
    # },
  using: {
    tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }

  def get_product_price
    if self.kind == 'Stock'
      if self.currency == 'USD'
        self.get_stock_price_from_json_fh
      else
        self.get_stock_price_from_json_av
      end
    elsif self.kind == 'Crypto'
      self.get_crypto_price_from_json_cmc
    end
  end

  def calc_valuation
    # expects an instance of a product
    self.calculate_total_valuation_of_a_product(self.get_product_price)
  end

  def get_stock_json_av
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{self.ticker}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_stock_json_fh
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://finnhub.io/api/v1/quote?symbol=#{self.ticker}&token=#{ENV['FINNHUB_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_crypto_json_av
    # expects an instance of a product. It will call alpha vantage API to get the quote
    url = open("https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=#{self.ticker}&to_currency=#{self.currency}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}").read
    return JSON.parse(url)
  end

  def get_crypto_json_cmc
    uri = URI("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest")
    params = { :symbol => self.ticker, :CMC_PRO_API_KEY => ENV['COIN_MARKET_CAP_API_KEY'] }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
  end

  def calculate_total_valuation_of_a_product(price)
    total = 0.0
    unless price.nil?
      self.purchases.each do |purchase|
        total += price * purchase.shares
      end
    end
    return total
  end

  def get_stock_price_from_json_fh
    quote_json = get_stock_json_fh
    unless quote_json["c"].zero?
      # if the API does not return the quote, it would skip the price retrieval
      price = quote_json["c"].to_f
      return price
    else
      return 0
    end
  end

  def get_stock_price_from_json_av
    quote_json = get_stock_json_av
    unless quote_json["Global Quote"].nil?
      # if the API does not return the quote, it would skip the price retrieval
      price = quote_json["Global Quote"]["05. price"].to_f
      return price
    else
      return 0
    end
  end

  def get_crypto_price_from_json_av
    quote_json = get_crypto_json_av
    unless quote_json["Realtime Currency Exchange Rate"].nil?
      price = quote_json["Realtime Currency Exchange Rate"]["5. Exchange Rate"].to_f
      return price
    else
      return 0
    end
  end

  def get_crypto_price_from_json_cmc
    quote_json = get_crypto_json_cmc
    unless quote_json["status"]["error_code"] == 400
      price = quote_json["data"][self.ticker]["quote"]["USD"]["price"].to_f
      return price
    else
      return 0
    end
  end
end
