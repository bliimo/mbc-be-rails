class AddStatusToRoulette < ActiveRecord::Migration[6.0]
  def change
    add_column :roulettes, :status, :integer, default: 0
  end
end
