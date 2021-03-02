class Platform < ApplicationRecord
  has_many :purchases
  has_many :products, through: :purchases
  validates :name, presence: true
end
