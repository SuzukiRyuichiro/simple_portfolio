class CreateDatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :date_prices do |t|
      t.references :product, null: false, foreign_key: true
      t.datetime :date
      t.float :price

      t.timestamps
    end
  end
end
