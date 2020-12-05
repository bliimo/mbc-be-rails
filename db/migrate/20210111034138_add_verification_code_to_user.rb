class AddVerificationCodeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :verification_code, :string
  end
end
