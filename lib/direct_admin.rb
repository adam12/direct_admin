require_relative "direct_admin/version"
require_relative "direct_admin/client"

module DirectAdmin
  Error = Class.new(StandardError)

  module Errors
    InvalidPassword = Class.new(Error)
  end
end
