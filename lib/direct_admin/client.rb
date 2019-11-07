# frozen_string_literal: true

require "logger"
require_relative "commands"
require_relative "request"

module DirectAdmin
  class Client
    include DirectAdmin::Commands

    # URL of the DirectAdmin server
    attr_accessor :url
    alias server_url url

    # Username to authenticate with
    attr_accessor :username
    alias server_username username

    # Password to authenticate with
    attr_accessor :password
    alias server_password password

    # Logger
    attr_accessor :logger

    # Create a new instance of the Client
    #
    # == Required Arguments
    #
    # :url :: The url of the DirectAdmin server.
    # :username :: A username to login as.
    # :password :: The password which correspondes to the username.
    # :logger :: A logger object
    def initialize(url:, username:, password:, logger: default_logger)
      @url = url
      @username = username
      @password = password
      @logger = logger
    end

    def request(method, endpoint, params) # :nodoc:
      Request.new(self, method, endpoint, params).call
    end

    private

    def default_logger
      Logger.new("/dev/null")
    end
  end
end
