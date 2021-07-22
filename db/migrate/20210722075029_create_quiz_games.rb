class CreateQuizGames < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_games do |t|
      t.string :title
      t.text :description
      t.integer :sponsor_id
      t.integer :city_id
      t.integer :radio_station_id
      t.text :price
      t.integer :number_of_winner
      t.datetime :schedule
      t.integer :status

      t.timestamps
    end
  end
end
