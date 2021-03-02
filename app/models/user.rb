class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :purchases
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, through: :purchases
  has_many :platforms, through: :purchases

end
