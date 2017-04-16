require "minitest/autorun"
require "direct_admin/client"
require "direct_admin/commands"

class TestCommands < Minitest::Test
  def stub_client
    client = DirectAdmin::Client.new(url: nil, username: nil, password: nil)

    def client.request(method, url, params)
      Struct.new(:method, :url, :params)
            .new(method, url, params)
    end

    client
  end

  def setup
    @client = stub_client
  end

  def test_create_login_key

    request = @client.create_login_key("test", "secret")

    assert_equal :post, request.method
    assert_equal "/CMD_API_LOGIN_KEYS", request.url
    assert_equal "test", request.params.fetch("keyname")
  end
end
