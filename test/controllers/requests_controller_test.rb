require "test_helper"
# TEST SUCCESS/FAILURE ON CREATING/DELETING - VIEWS ASWELL- CHECK PRESENCE OF TEXT IN PAGE
# NO MODEL TESTING FOR NOW
class RequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Get Requests" do
    sign_in users(:three)
    get requests_url
    assert_response :success
  end

  test "Get Sent Requests" do
    sign_in users(:four)
    get requests_sent_url
    assert_response :success
  end
end
