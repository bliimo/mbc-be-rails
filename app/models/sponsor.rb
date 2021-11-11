class Sponsor < ApplicationRecord
  has_many :quiz_games
  has_many :roulettes

  enum status: ["Active", "Inactive"]
  validates :name, presence: true, uniqueness: true
end
