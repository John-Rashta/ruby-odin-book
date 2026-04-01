require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Get Posts" do
    sign_in users(:one)
    get posts_url
    assert_response :success
  end

  test "Get Post" do
    sign_in users(:one)
    get post_url(posts(:one).id)
    assert_response :success
  end
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

  test "Can't Edit Someone Else's Post" do
    sign_in users(:three)
    patch post_url(posts(:one).id), params: { post: { content: "DD" } }
    assert_response :not_found
    posts(:one).reload
    assert_equal "MyTextA", posts(:one).content
  end

  # VIEWS
  test "Posts View" do
    sign_in users(:three)
    get posts_url
    assert_dom "div", "MyTextB"
    assert_dom "div", "MyTextD"
    assert_dom "div", "0"
    assert_dom "div", "David"
    assert_dom "div", "Sarah"
  end

  test "Post View" do
    sign_in users(:one)
    get post_url(posts(:one).id)
    assert_dom "div", "MyTextA"
    assert_dom "div", "MyStringA"
    assert_dom "div", "David"
    assert_dom "div", "John"
    assert_dom "div", "0"
  end
end
