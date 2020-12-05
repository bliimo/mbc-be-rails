class AddConfirmationTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :verified_at, :datetime
  end
end
