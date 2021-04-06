class MbcUser < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "user"
  has_many :notifications
end
