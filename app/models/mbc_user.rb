class MbcUser < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "user"
  has_many :notifications

  # enum gender: ["FEMALE", "UNDISCLOSED", "MALE"]
  # enum user_type: ["audience", "dj", "admin"]

  def valid_password? (password)
    BCrypt::Password.new(MbcUser.first.password) == password
  end
end
