class AddEndTimeToRoulette < ActiveRecord::Migration[6.0]
  def change
    add_column :roulettes, :end_time, :datetime
  end
end
