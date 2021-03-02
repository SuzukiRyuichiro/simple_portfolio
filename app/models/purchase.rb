class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :platform
  belongs_to :user
  validates :shares, presence: true
  validates :date, presence: true
end
