class Roulette < ApplicationRecord
  belongs_to :radio_station
  belongs_to :city, optional: true

end
