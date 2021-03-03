class AddCurrencyToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :currency, :string
  end
end
