class CreateMobileReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :mobile_releases do |t|
      t.integer :build_code
      t.integer :android_update_type
      t.integer :ios_update_type
      t.integer :android_number_of_installs
      t.integer :ios_number_of_installs
      t.boolean :maintenance_mode

      t.timestamps
    end
  end
end
