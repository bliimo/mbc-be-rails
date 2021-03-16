class AddStatusToGameRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :game_records, :status, :integer
  end
end
