class Product < ApplicationRecord
  has_many :purchases
  has_many :platforms, through: :purchases
  validates :name, presence: true
end
