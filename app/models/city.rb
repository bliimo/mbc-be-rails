class City < ActiveRecord::Base
  has_and_belongs_to_many :roulettes
  accepts_nested_attributes_for :roulettes

  belongs_to :province
  has_many :quiz_games, :foreign_key => "city_id", :class_name => "QuizGame" 
  default_scope { order(name: :asc) }

 

  def label_name
    "#{province.name} | #{name}"
  end
end
