class AddNumberOfWinnerToGameRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :game_records, :number_of_winners, :integer
  end
end
