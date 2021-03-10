require 'open-uri'

class NewsJob < ApplicationJob
  queue_as :default

  def perform
    json = open("https://finnhub.io/api/v1/news?category=general&token=#{ENV['FINNHUB_API_KEY']}").read
    return JSON.parse(json, symbolize_names: true)
  end
end
