class Product < ApplicationRecord
  has_many :purchases
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
end
