class Sponsor < ApplicationRecord
  has_many :quiz_games
  has_many :roulettes

  enum status: ["Active", "Inactive"]
  validates :name, presence: true, uniqueness: {:case_sensitive => false}
end
