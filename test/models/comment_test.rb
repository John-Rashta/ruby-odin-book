require "test_helper"

class CommentTest < ActiveSupport::TestCase
   test "Get's likes" do
    likes = comments(:two).likes
    assert_equal likes[0], likes(:three)
  end

  test "Get's users that liked" do
    like_users = comments(:two).like_users
    assert_equal like_users[0], users(:one)
  end

  test "Get's comment comments" do
    comment_comments = comments(:one).comments
    assert_equal comment_comments[0], comments(:three)
  end
end
