class City < ActiveRecord::Base
  belongs_to :province
  has_many :quiz_games, :foreign_key => "city_id", :class_name => "QuizGame" 
end
