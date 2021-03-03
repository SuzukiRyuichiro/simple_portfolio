class AddPriceAtPurchaseToPurchases < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :price_at_purchase, :float
  end
end
