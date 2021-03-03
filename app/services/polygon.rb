class Polygon
  include HTTParty

  def initialize(symbol)
    @symbol = symbol
  end
  def run
    responses = HTTParty.get("https://api.polygon.io/v1/meta/symbols/#{@symbol}/news?perpage=5&page=1&apiKey=#{ENV['POLYGON']}")
    JSON.parse(responses.body)
  end
end

# polygon = Polygon.new(symbol)
#  polygon.run
