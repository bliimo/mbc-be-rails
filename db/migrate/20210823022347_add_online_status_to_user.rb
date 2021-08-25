class AddOnlineStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :online_status, :integer, default: 0
    add_column :users, :last_online, :datetime
  end
end
