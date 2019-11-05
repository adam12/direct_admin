require "minitest/autorun"
require "direct_admin/request"

class TestRequest < Minitest::Test
  def test_parse_response_basic
    response = "error=0&text=text&details=details"

    request = DirectAdmin::Request.new(nil, nil, nil, nil)
    parsed_response = request._parse_response(response)

    assert_equal "0", parsed_response["error"]
    assert_equal "text", parsed_response["text"]
    assert_equal "details", parsed_response["details"]
  end

  def test_call
    skip
  end
end
