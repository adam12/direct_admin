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

  def test_email_auth
    @client.response = { "error" => "0" }

    assert @client.email_auth("user@domain.com", "secret")
    assert_equal "/CMD_API_EMAIL_AUTH", @client.url
    assert_equal "user@domain.com", @client.params["email"]
    assert_equal "secret", @client.params["passwd"]
  end

  def test_domain_owner
    @client.response = { "domain.com" => {} }

    assert @client.domain_owner("domain.com")
  end

  def test_email_account_quota
    @client.response = {
      "error" => "0",
      "imap" => "1789607297",
      "imap_bytes" => "1727128449",
      "inbox" => "866553862",
      "inbox_bytes" => "849345066",
      "last_password_change" => "0",
      "spam" => "27492571",
      "spam_bytes" => "27492571",
      "total" => "2656161159",
      "total_bytes" => "2576473515",
      "webmail" => "0",
      "webmail_bytes" => "0"
    }

    refute_nil @client.email_account_quota(email_address: "user@example.com", password: "secret")
  end
end
