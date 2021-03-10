require 'open-uri'

class Api::V1::NewsController < Api::V1::BaseController

  def index
    json = open("https://finnhub.io/api/v1/news?category=general&token=#{ENV['FINNHUB_API_KEY']}").read
    @finnhub_articles = JSON.parse(json, symbolize_names: true)
    @finnhub_articles = @finnhub_articles.flatten.map do |article|
      render_to_string(partial: 'card.html.erb', locals: {article: article})
    end
      render json: @finnhub_articles
  end
end
