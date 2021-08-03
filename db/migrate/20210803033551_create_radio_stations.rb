class CreateRadioStations < ActiveRecord::Migration[6.0]
  def change
    create_table :radio_stations do |t|
      t.references :network, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :frequency
      t.string :audio_streaming_link
      t.string :video_string_link
      t.integer :status
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
