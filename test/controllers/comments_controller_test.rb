require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Successfull Comment Creation" do
    sign_in users(:one)
    assert_difference("Comment.count", 1) do
      post post_comments_url(posts(:one).id), params: { comment: { content: "hello" } }
    end
    assert_response :success
  end

  test "Successfull Comment on Another Comment" do
    sign_in users(:one)
    assert_difference("Comment.count", 1) do
      post comment_comments_url(comments(:one).id), params: { comment: { content: "hello" } }
    end
    assert_response :success
  end
  test "Comment can't be empty" do
    sign_in users(:one)
    post post_comments_url(posts(:one).id), params: { comment: { content: "" } }
    assert_response :bad_request
  end

  test "Successfully deleted Comment" do
    sign_in users(:one)
    assert_difference("Comment.count", -1) do
      delete comment_url(comments(:four).id)
    end
    assert_response :success
  end

  test "Successfully deleted Comment and it's comment children" do
    sign_in users(:one)
    assert_difference("Comment.count", -2) do
      delete comment_url(comments(:one).id)
    end
    assert_response :success
  end

  test "Can't delete another person's comment" do
    sign_in users(:three)
    assert_difference("Comment.count", 0) do
      delete comment_url(comments(:one).id)
    end
    assert_response :not_found
  end

  test "Can't delete comment that doesn't exist" do
    sign_in users(:three)
    assert_difference("Comment.count", 0) do
      delete comment_url(54456)
    end
    assert_response :not_found
  end

  test "Edit Comment" do
    sign_in users(:one)
    patch comment_url(comments(:one).id), params: { comment: { content: "DD" } }
    assert_response :success
    comments(:one).reload
    assert_equal "DD", comments(:one).content
  end
  test "Can't Edit To Empty Comment" do
    sign_in users(:one)
    patch comment_url(comments(:one).id), params: { comment: { content: "" } }
    assert_response :bad_request
    comments(:one).reload
    assert_equal "MyStringA", comments(:one).content
  end

  test "Can't Edit Someone Else's Comment" do
    sign_in users(:three)
    patch comment_url(comments(:one).id), params: { comment: { content: "DD" } }
    assert_response :not_found
    comments(:one).reload
    assert_equal "MyStringA", comments(:one).content
  end

  test "Get Comment" do
    sign_in users(:one)
    get comment_url(comments(:one).id)
    assert_response :success
  end

  test "Can't get comment that doesn't exist" do
    sign_in users(:one)
    get comment_url(55)
    assert_response :not_found
  end

  # VIEWS
  test "Comment View" do
    sign_in users(:one)
    get comment_url(comments(:one).id)
    assert_dom "div", "MyStringA"
    assert_dom "div", "MyStringC"
    assert_dom "div", "David"
    assert_dom "div", "0"
    assert_dom "button", 3
  end
end
