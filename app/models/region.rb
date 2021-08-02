class Region < ApplicationRecord
  has_many :provinces, dependent: :destroy
end
