class CreateRoulettes < ActiveRecord::Migration[6.0]
  def change
    create_table :roulettes do |t|
      t.references :radio_station, null: false, foreign_key: true
      t.boolean :location_restriction
      t.integer :city_id
      t.integer :location_restriction_type
      t.text :text_description
      t.integer :dj_id
      t.integer :sponsor_id
      t.string :name
      t.integer :number_of_winner
      t.string :price
      t.datetime :schedule
      t.text :redemption_details
      t.string :dti_permit
      t.string :winner_prompt
      t.boolean :popper_visible
      t.boolean :banderitas_visible

      t.timestamps
    end
  end
end
