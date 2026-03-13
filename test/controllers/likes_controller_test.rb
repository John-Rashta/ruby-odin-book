require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Successfull Like Creation" do
    sign_in users(:one)
     assert_difference("Like.count", 1) do
      post post_likes_url(posts(:three).id)
    end
    assert_response :success
  end

  test "Can't Like a Post that doesn't exist" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      post post_likes_url(534)
    end
    assert_response :bad_request
  end

  test "Can't Like Twice" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      post post_likes_url(posts(:one).id)
    end
    assert_response :bad_request
  end

  test "Successfully deleted Like" do
    sign_in users(:one)
    assert_difference("Like.count", -1) do
      delete post_likes_url(posts(:one).id)
    end
    assert_response :success
  end

  test "Can't Delete A Like That doesn't Exist" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      delete post_likes_url(posts(:two).id)
    end
    assert_response :not_found
  end
end
