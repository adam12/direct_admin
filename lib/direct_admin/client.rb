require_relative "commands"
require_relative "request"

module DirectAdmin
  class Client
    include DirectAdmin::Commands

    attr_accessor :url, :username, :password

    alias server_username username
    alias server_password password
    alias server_url url

    def initialize(url:, username:, password:)
      @url = url
      @username = username
      @password = password
    end

    def _request(method, endpoint, params)
      Request.new(self, method, endpoint, params)
    end
  end
end
