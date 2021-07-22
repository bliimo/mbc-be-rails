class City < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "city_municipality"

  has_many :quiz_games, :foreign_key => "city_id", :class_name => "QuizGame" 

  def name
    city_municipality_name
  end
end
