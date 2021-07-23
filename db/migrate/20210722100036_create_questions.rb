class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :quiz_game, null: false, foreign_key: true
      t.text :question
      t.integer :countdown_in_seconds

      t.timestamps
    end
  end
end
