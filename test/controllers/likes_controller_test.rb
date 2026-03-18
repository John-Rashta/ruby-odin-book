require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # POST
  test "Successfull Like Creation Post" do
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

  test "Can't Like Post Twice" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      post post_likes_url(posts(:one).id)
    end
    assert_response :bad_request
  end

  test "Successfully deleted Like To Post" do
    sign_in users(:one)
    assert_difference("Like.count", -1) do
      delete post_likes_url(posts(:one).id)
    end
    assert_response :success
  end

  test "Can't Delete A Like To Post That doesn't Exist" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      delete post_likes_url(posts(:two).id)
    end
    assert_response :not_found
  end

  # COMMENT

  test "Successfull Like Creation Comment" do
    sign_in users(:three)
     assert_difference("Like.count", 1) do
      post comment_likes_url(comments(:one).id)
    end
    assert_response :success
  end

  test "Can't Like a Comment that doesn't exist" do
    sign_in users(:three)
    assert_difference("Like.count", 0) do
      post comment_likes_url(1235)
    end
    assert_response :bad_request
  end

  test "Can't Like Comment Twice" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      post comment_likes_url(comments(:two).id)
    end
    assert_response :bad_request
  end

  test "Successfully deleted Like To Comment" do
    sign_in users(:one)
    assert_difference("Like.count", -1) do
      delete comment_likes_url(comments(:two).id)
    end
    assert_response :success
  end

  test "Can't Delete A Like To Comment That doesn't Exist" do
    sign_in users(:one)
    assert_difference("Like.count", 0) do
      delete comment_likes_url(comments(:one).id)
    end
    assert_response :not_found
  end
end
