class AddMoreInfoToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_column :users, :contact_number, :string
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :birthday, :date
    add_column :users, :role, :integer
    add_column :users, :status, :integer
  end
end
