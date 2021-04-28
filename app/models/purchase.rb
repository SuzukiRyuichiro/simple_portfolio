class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :platform
  belongs_to :user
  validates :shares, presence: true
  validates :date, presence: true
  validates :price_at_purchase, presence: true

  def margin_at(current_price)
    (current_price - price_at_purchase) * current_price
  end
end
