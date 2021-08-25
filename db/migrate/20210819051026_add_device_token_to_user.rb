class AddDeviceTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :token, :string
    add_column :users, :last_login, :datetime
    add_column :users, :manufacturer, :string
    add_column :users, :device_id, :string
    add_column :users, :device_name, :string
    add_column :users, :brand, :string
    add_column :users, :ip_address, :string
    add_column :users, :model, :string
    add_column :users, :mac_address, :string
    add_column :users, :carrier, :string
    add_column :users, :system_version, :string
  end
end
