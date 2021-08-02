class AddAddressToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :region_id, :integer
    add_column :users, :province_id, :integer
    add_column :users, :city_id, :integer
  end
end
