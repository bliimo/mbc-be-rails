class CreatePies < ActiveRecord::Migration[6.0]
  def change
    create_table :pies do |t|
      t.references :roulette, null: false, foreign_key: true
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
