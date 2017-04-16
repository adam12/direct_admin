require "http"
require_relative "commands"

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
  end
end
