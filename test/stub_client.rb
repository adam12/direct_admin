require "forwardable"

module StubClient
  extend Forwardable

  class Request
    attr_reader :method, :url, :params

    def initialize(method, url, params)
      @method = method
      @url = url
      @params = params
    end
  end

  class Response < Hash
  end

  attr_reader :response

  def_delegators :@request, :method, :url, :params

  def request(method, url, params)
    @request = Request.new(method, url, params)

    @response
  end

  def response=(hash)
    @response = Response[hash]
  end
end
