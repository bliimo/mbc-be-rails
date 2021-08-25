class ChangeFrequencyScaleFromRadioStation < ActiveRecord::Migration[6.0]
  def change
    change_column :radio_stations, :frequency, :decimal, :precision => 8, :scale => 2
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
