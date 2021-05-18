class FacebookUser < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "facebook_user"
  belongs_to :user, class_name: "MbcUser", foreign_key: "audience_id"
end
