require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

class GetPriceJob < ApplicationJob
  queue_as :critical

  def perform(product_id)
    @product = Product.find(product_id)
    @product.get_product_price
  end
end
