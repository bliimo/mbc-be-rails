class CreateNetworksAdminUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_users_networks, id: false do |t|
      t.belongs_to :network
      t.belongs_to :admin_user
    end
  end
end
