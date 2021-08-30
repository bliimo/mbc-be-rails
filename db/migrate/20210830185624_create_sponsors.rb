class CreateSponsors < ActiveRecord::Migration[6.0]
  def change
    create_table :sponsors do |t|
      t.string :name
      t.text :description
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
