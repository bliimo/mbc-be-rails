class CreateUserNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_notifications do |t|
      t.integer :user_id
      t.references :notification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
