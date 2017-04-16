require "minitest/autorun"
require "direct_admin/client"
require "direct_admin/commands"
require_relative "stub_client"

class TestCommands < Minitest::Test
  def stub_client
    client = DirectAdmin::Client.new(url: nil, username: nil, password: nil)
    client.extend(StubClient)
  end

  def setup
    @client = stub_client
  end

  def test_create_login_key
    @client.response = { "error" => "0" }
    assert @client.create_login_key("test", "secret")

    assert_equal :post, @client.method
    assert_equal "/CMD_API_LOGIN_KEYS", @client.url
    assert_equal "test", @client.params["keyname"]
  end

  def test_verify_password
    @client.response = { "valid" => "1" }

    assert @client.verify_password("admin", "secret")
    assert_equal :post, @client.method
    assert_equal "/CMD_API_VERIFY_PASSWORD", @client.url
    assert_equal "admin", @client.params["user"]
    assert_equal "secret", @client.params["passwd"]
  end
end
