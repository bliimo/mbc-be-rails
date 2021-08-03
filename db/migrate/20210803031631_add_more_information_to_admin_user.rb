class AddMoreInformationToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :role, :integer, default: 0
    add_column :admin_users, :status, :integer, default: 0
  end
end
