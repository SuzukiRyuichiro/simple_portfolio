class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :platform
  belongs_to :user
  validates :shares, presence: true
  validates :date, presence: true

  def margin_at(current_price)
    (current_price * shares - price_at_purchase * shares).round(2)
  end
end
