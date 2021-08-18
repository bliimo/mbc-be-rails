class Add3rdParthLoginToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :login_type, :integer, default: 0
    add_column :users, :auth_id, :string
  end
end
