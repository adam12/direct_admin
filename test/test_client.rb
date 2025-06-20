require "test_helper"
require "direct_admin"

class TestClient < Minitest::Test
  def test_initialization
    assert DirectAdmin::Client.new(url: nil, username: nil, password: nil)
  end
end
