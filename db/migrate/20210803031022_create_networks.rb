class CreateNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :networks do |t|
      t.string :name
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
