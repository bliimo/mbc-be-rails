class RenameAndDeleteColumnFromMobileRelease < ActiveRecord::Migration[6.0]
  def change
    rename_column :mobile_releases, :android_update_type, :update_type
    remove_column :mobile_releases, :ios_update_type
    remove_column :mobile_releases, :android_number_of_installs
    remove_column :mobile_releases, :ios_number_of_installs
  end
end
