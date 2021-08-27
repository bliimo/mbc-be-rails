class CreateRoulleteCity < ActiveRecord::Migration[6.0]
  def change
    create_table :cities_roulettes do |t|
      t.belongs_to :roulette
      t.belongs_to :city
    end
  end
end
