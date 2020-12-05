module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      puts 'Connection has been established'
    end
  end
end
