class RemoveAdminUserFromNetwork < ActiveRecord::Migration[6.0]
  def change
    remove_column :networks, :admin_user_id, :integer
  end
end
