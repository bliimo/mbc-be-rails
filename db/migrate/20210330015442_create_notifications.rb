class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.integer :game_id
      t.datetime :schedule

      t.timestamps
    end
  end
end
