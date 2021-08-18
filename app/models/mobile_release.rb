class MobileRelease < ApplicationRecord
  enum update_type: ['No notice', 'Notify update', 'Force update']
  validates :build_code, presence: true, uniqueness: true
end
