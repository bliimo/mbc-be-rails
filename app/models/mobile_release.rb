class MobileRelease < ApplicationRecord
  enum android_update_type: ['android_no_notice', 'android_notify_user', 'android_force_update']
  enum ios_update_type: ['ios_no_notice', 'ios_notify_user', 'ios_force_update']

  validates :build_code, presence: true, uniqueness: true
  validates :android_update_type, presence: true
  validates :ios_update_type, presence: true
  
end
