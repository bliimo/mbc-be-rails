class RemoveCityFromRoulette < ActiveRecord::Migration[6.0]
  def change
    remove_column :roulettes, :city_id

  end
end
