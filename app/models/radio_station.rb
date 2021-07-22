class RadioStation < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "radio_station"
  has_many :quiz_games, :foreign_key => "radio_station_id", :class_name => "QuizGame" 

  def name
    radio_station_name
  end
end
