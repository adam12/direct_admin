# frozen_string_literal: true
require "uri"
require "cgi"
require "http"

module DirectAdmin
  class Request
    attr_reader :method, :endpont, :params, :url

    def initialize(client, method, endpoint, params)
      @method   = method
      @endpoint = endpoint
      @params   = params
      @url      = URI.join(client.server_url, endpoint).to_s if client
    end

    def call
      response = _make_request

      if response.status == 404
        raise DirectAdmin::Error, "Invalid URL: #{url}"
      end

      parsed_body = _parse_response(response.to_s)

      unless response.code == 200
        raise DirectAdmin::Error, parsed_body["reason"]
      end

      parsed_body
    end

    def _make_request
      HTTP.basic_auth(user: client.server_username, pass: client.server_password)
          .public_send(method, url, form: params)
    end

    def _parse_response(response)
      CGI.parse(response).reduce({}) do |memo, (key, value)|
        if value.is_a?(Array) && value.length == 1
          memo[key] = value.first
        else
          memo[key] = value
        end

        memo
      end
    end
  end
end
