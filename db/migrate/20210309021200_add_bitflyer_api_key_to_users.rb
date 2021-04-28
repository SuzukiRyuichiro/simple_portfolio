class AddBitflyerApiKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :bitflyer_api_key, :string
  end
end
