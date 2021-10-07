class AddPriorityToRadioStation < ActiveRecord::Migration[6.0]
  def change
    add_column :radio_stations, :priority, :decimal
  end
end
