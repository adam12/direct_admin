require "http"

module DirectAdmin
  class Client
    attr_accessor :url, :username, :password

    def initialize(url:, username:, password:)
      @url = url
      @username = username
      @password = password
    end
  end
end
