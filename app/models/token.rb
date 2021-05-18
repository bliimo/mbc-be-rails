class Token < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "token"
  belongs_to :user, class_name: "MbcUser", foreign_key: "user_id", optional: true
end
