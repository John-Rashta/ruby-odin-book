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

  test "Successfull Request Creation" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: users(:four).id, table_type: "follow" } }
    assert_response :success
  end

  test "Invalid Table Type" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: users(:two).id, table_type: "ss" } }
    assert_response :bad_request
    assert_equal "Something Went Wrong!", flash[:alert]
  end

  test "Invalid User id" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: "ASG", table_type: "follow" } }
    assert_response :bad_request
    assert_equal "Failed to send request!", flash[:alert]
  end

  test "Can't send request to yourself" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: users(:one).id, table_type: "follow" } }
    assert_response :bad_request
    assert_equal "Can't send request to yourself!", flash[:alert]
  end

  test "User doesn't exist" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: 12, table_type: "follow" } }
    assert_response :bad_request
    assert_equal "Failed to send request!", flash[:alert]
  end

  test "Can't duplicate Request" do
    sign_in users(:one)
    post requests_url, params: { request: { user_id: users(:two).id, table_type: "follow" } }
    post requests_url, params: { request: { user_id: users(:two).id, table_type: "follow" } }
    assert_response :bad_request
    assert_equal "Failed to send request!", flash[:alert]
  end

  # TODO TEST DESTROY
  test "Sucessfully delete received request" do
    sign_in users(:three)
    assert_difference("Request.count", -1) do
      delete request_url(requests(:one).id)
    end
    assert_response :success
  end

  test "Sucessfully delete sent request" do
    sign_in users(:four)
    assert_difference("Request.count", -1) do
      delete request_url(requests(:one).id)
    end
    assert_response :success
  end

  test "Invalid Id for Delete" do
    sign_in users(:three)
    assert_difference("Request.count", 0) do
      delete request_url("dsaf")
    end

    assert_equal "Failed to delete request!", flash[:alert]
    assert_response :bad_request
  end

  test "Non-existent Id for Delete" do
    sign_in users(:three)
    assert_difference("Request.count", 0) do
      delete request_url(551233)
    end

    assert_equal "Failed to delete request!", flash[:alert]
    assert_response :bad_request
  end

   test "Can't delete other people's requests" do
    sign_in users(:one)
    assert_difference("Request.count", 0) do
      delete request_url(requests(:one).id)
    end

    assert_equal "Failed to delete request!", flash[:alert]
    assert_response :bad_request
  end
  # VIEWS
  test "Requests View" do
    sign_in users(:three)
    get requests_url
    assert_dom "div", "follow"
    assert_dom "div", "Jenny"
    assert_dom "button", "Reject Request"
  end

  test "Sent Requests View" do
    sign_in users(:four)
    get requests_sent_url
    assert_dom "div", "follow"
    assert_dom "div", "Jenny"
    assert_dom "button", "Cancel Request"
  end
end
