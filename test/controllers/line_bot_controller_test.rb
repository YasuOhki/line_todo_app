require "test_helper"

class LineBotControllerTest < ActionDispatch::IntegrationTest
  test "should get action_callback" do
    get line_bot_action_callback_url
    assert_response :success
  end
end
