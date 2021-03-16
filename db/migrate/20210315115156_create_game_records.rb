class CreateGameRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :game_records do |t|
      t.integer :game_id
      t.datetime :start_time
      t.string :winners

      t.timestamps
    end
  end
end
