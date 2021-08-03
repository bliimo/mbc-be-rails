class City < ActiveRecord::Base
  belongs_to :province
  has_many :quiz_games, :foreign_key => "city_id", :class_name => "QuizGame" 
  default_scope { order(name: :asc) }

end
