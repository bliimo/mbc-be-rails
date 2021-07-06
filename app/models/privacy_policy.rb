class PrivacyPolicy < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "privacy_policy"
end
