class CreateValuations < ActiveRecord::Migration[6.1]
  def change
    create_table :valuations do |t|
      t.integer :total_valuation
      t.references :user, null: false, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
