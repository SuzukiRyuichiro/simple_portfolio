class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :purchases
  has_many :valuations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, through: :purchases
  has_many :platforms, through: :purchases

  def average_purchased_price(product)
    product_purchases = purchases.where(product: product)
    return nil unless product_purchases.any?

    return product_purchases.sum('price_at_purchase * shares') / product_purchases.sum(:shares)
  end
end
