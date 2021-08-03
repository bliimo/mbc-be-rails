class Region < ApplicationRecord
  has_many :provinces, dependent: :destroy
  default_scope { order(name: :asc) }

end
