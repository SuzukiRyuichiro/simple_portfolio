class AddFinnhubSymbolToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :finnhub_symbol, :string
  end
end
