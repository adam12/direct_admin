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

  def test_account_vacation_message
    raw_response = <<~EOM.gsub(/\n/, "")
    error=1&text=No vacation message set&custom%5Freply%5Fheaders=%31&reply%5Fcharset=&reply%5Fcontent%5Ftypes=%3Cselect%20class%3Dselectclass%20id%3Dreply%5Fcontent%5Ftype%20name%3Dreply%5Fconten
    t%5Ftype%3E%0A%3Coption%20value%3D%22text%2Fhtml%22%3Etext%2Fhtml%3C%2Foption%20%3E%0A%3Coption%20selected%20value%3D%22text%2Fplain%22%3Etext%2Fplain%3C%2Foption%20%3E%0A%3C%2Fselect%20%3E&re
    ply%5Fencodings=%3Cselect%20class%3Dselectclass%20id%3Dreply%5Fencoding%20name%3Dreply%5Fencoding%3E%0A%3Coption%20selected%20value%3D%22UTF%2D%38%22%3EUTF%2D%38%3C%2Foption%20%3E%0A%3Coption%
    20value%3D%22iso%2D%38%38%35%39%2D%31%22%3Eiso%2D%38%38%35%39%2D%31%3C%2Foption%20%3E%0A%3C%2Fselect%20%3E&reply%5Fonce%5Fselect=%3Cselect%20class%3Dselectclass%20name%3Dreply%5Fonce%5Ftime%3E
    %0A%3Coption%20value%3D%22%31m%22%3E%31%20minutes%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%31%30m%22%3E%31%30%20minutes%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%33%30m%22%3E%33%30%20minu
    tes%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%31h%22%3E%31%20hours%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%32h%22%3E%32%20hours%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%36h%22%3E%36%2
    0hours%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%31%32h%22%3E%31%32%20hours%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%31d%22%3E%31%20days%3C%2Foption%20%3E%0A%3Coption%20selected%20value%3
    D%22%32d%22%3E%32%20days%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%33d%22%3E%33%20days%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%34d%22%3E%34%20days%3C%2Foption%20%3E%0A%3Coption%20value%3
    D%22%35d%22%3E%35%20days%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%36d%22%3E%36%20days%3C%2Foption%20%3E%0A%3Coption%20value%3D%22%37d%22%3E%37%20days%3C%2Foption%20%3E%0A%3C%2Fselect%20%3E&
    reply%5Fsubject=Autoreply&string=22
    EOM

    @client.response = DirectAdmin::ResponseBody.build(raw_response)

    refute_nil @client.get_account_vacation_message(email_address: "user@example.com", password: "secret")
  end
end
