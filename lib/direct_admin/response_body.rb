# frozen-string-literal: true

require "cgi"
require "forwardable"

module DirectAdmin
  class ResponseBody < DelegateClass(Hash)
    def self.build(raw_body)
      new(CGI.parse(raw_body).reduce({}) do |memo, (key, value)|
        if value.is_a?(Array) && value.length == 1
          memo[key] = value.first
        else
          memo[key] = value
        end

        memo
      end)
    end
  end
end
