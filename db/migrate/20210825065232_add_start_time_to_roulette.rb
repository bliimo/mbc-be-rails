class AddStartTimeToRoulette < ActiveRecord::Migration[6.0]
  def change
    add_column :roulettes, :start_time, :datetime
  end
end
