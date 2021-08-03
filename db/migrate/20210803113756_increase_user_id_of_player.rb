class IncreaseUserIdOfPlayer < ActiveRecord::Migration[6.0]
  def change
    change_column :players, :user_id, :bigint
  end
end
