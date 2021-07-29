class Sponsor < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "sponsor"
  has_many :quiz_games, :foreign_key => "sponsor_id", :class_name => "QuizGame" 

  def name
    sponsor_name
  end
end
