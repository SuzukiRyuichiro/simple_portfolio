class AddKindToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :kind, :string
  end
end
