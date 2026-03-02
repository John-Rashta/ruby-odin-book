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
end
