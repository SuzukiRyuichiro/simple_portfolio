class AddBitflyerApiSecretToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :bitflyer_api_secret, :string
  end
end
