# frozen_string_literal: true

require "uri"
require "http"
require_relative "response_body"

module DirectAdmin
  class Request
    attr_reader :client, :method, :endpont, :params, :url, :authenticate

    def initialize(client, method, endpoint, params, authenticate: true)
      @client   = client
      @method   = method
      @endpoint = endpoint
      @params   = params
      @authenticate = authenticate
      @url      = URI.join(client.server_url, endpoint).to_s
    end

    def call
      response = _make_request

      if response.status == 404
        raise DirectAdmin::Error, "Invalid URL: #{url}"
      end

      parsed_body = ResponseBody.build(response.to_s)

      unless response.code == 200
        raise DirectAdmin::Error, parsed_body["reason"]
      end

      parsed_body
    end

    def _make_request
      HTTP
        .use(logging: {logger: client.logger})
        .then { |http|
          next http if !authenticate
          http.basic_auth(user: client.server_username, pass: client.server_password)
        }
        .public_send(method, url, form: params)
    end
  end
end
