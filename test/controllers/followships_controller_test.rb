require "test_helper"

# TEST SUCCESS/FAILURE ON CREATING/DELETING - VIEWS WILL SEE LATER
class FollowshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Get Followers" do
    sign_in users(:one)
    get followships_followers_url
    assert_response :success
  end

  test "Get Followings" do
    sign_in users(:three)
    get followships_url
    assert_response :success
  end

  test "Successfull Follow Accept" do
    sign_in users(:three)
    post followships_url, params: { request: { id: requests(:one).id } }
    assert_response :success
  end
  # MAYBE ASSERT THAT DESTROY AND FOLLOWSHIP CREATION HAPPENS LIKE +1 AND -1
  test "Deletes Request on Follow Accept" do
    sign_in users(:three)
    assert_difference("Request.count", -1) do
      post followships_url, params: { request: { id: requests(:one).id } }
    end
    assert_response :success
  end

  test "Creates Followship on Follow Accept" do
    sign_in users(:three)
    assert_difference("Followship.count", 1) do
      post followships_url, params: { request: { id: requests(:one).id } }
    end
    assert_response :success
  end

  test "Can't accept non-existent request" do
    sign_in users(:three)
    post followships_url, params: { request: { id: "dffg" } }
    assert_equal "Record not found.", flash[:alert]
    assert_response :not_found
  end

  # TODO TEST DESTROY
  test "Sucessfully delete followship" do
    sign_in users(:three)
    assert_difference("Followship.count", -1) do
      delete followships_url, params: { follow: { user_id: users(:one).id } }
    end
    assert_response :success
  end

  test "No followship found to delete" do
    sign_in users(:three)
    assert_difference("Followship.count", 0) do
      delete followships_url, params: { follow: { user_id: 235 } }
    end
    assert_equal "Record not found.", flash[:alert]
    assert_response :not_found
  end

  # VIEWS
  test "Followers View" do
    sign_in users(:one)
    get followships_followers_url
    assert_dom "div", "Sarah"
  end

  test "Followings View" do
    sign_in users(:three)
    get followships_url
    assert_dom "div", "David"
  end
end
