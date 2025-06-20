require "test_helper"
require "direct_admin/response_body"

class TestResponseBody < Minitest::Test
  def test_parse_basic_response
    raw_body = "error=0&text=text&details=details"

    parsed_response = DirectAdmin::ResponseBody.build(raw_body)

    assert_equal "0", parsed_response["error"]
    assert_equal "text", parsed_response["text"]
    assert_equal "details", parsed_response["details"]
  end
end
