class CreateRouletteParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :roulette_participants do |t|
      t.references :roulette, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :spin_at
      t.boolean :winner

      t.timestamps
    end
  end
end
