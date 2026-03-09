require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Successfull Post Creation" do
    sign_in users(:one)
    post posts_url, params: { post: { content: "hello" } }
    assert_response :success
  end
  test "Post can't be empty" do
    sign_in users(:one)
    post posts_url, params: { post: { content: "" } }
    assert_response :bad_request
  end

  test "Successfully deleted Post" do
    sign_in users(:two)
    assert_difference("Post.count", -1) do
      delete post_url(posts(:one).id)
    end
    assert_response :success
  end

  test "Can't delete another person's post" do
    sign_in users(:three)
    assert_difference("Post.count", 0) do
      delete post_url(posts(:one).id)
    end
    assert_response :not_found
  end

  test "Can't delete post that doesn't exist" do
    sign_in users(:three)
    assert_difference("Post.count", 0) do
      delete post_url(54456)
    end
    assert_response :not_found
  end

  test "Edit Post" do
    sign_in users(:two)
    patch post_url(posts(:one).id), params: { post: { content: "DD" } }
    assert_response :success
    posts(:one).reload
    assert_equal "DD", posts(:one).content
  end
  test "Can't Edit To Empty Post" do
    sign_in users(:two)
    patch post_url(posts(:one).id), params: { post: { content: "" } }
    assert_response :bad_request
    posts(:one).reload
    assert_equal "MyTextA", posts(:one).content
  end

  test "Can't Edit To Someone Else's Post" do
    sign_in users(:three)
    patch post_url(posts(:one).id), params: { post: { content: "DD" } }
    assert_response :not_found
    posts(:one).reload
    assert_equal "MyTextA", posts(:one).content
  end
end
