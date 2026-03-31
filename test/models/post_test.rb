require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "Get Creator" do
    creator = posts(:one).creator
    assert_equal creator, users(:two)
  end
  test "Get's likes" do
    likes = posts(:one).likes
    assert_equal likes[0], likes(:one)
  end

  test "Get's users that liked" do
    like_users = posts(:one).like_users
    assert_equal like_users[0], users(:one)
  end

  test "Get's posts comments" do
    post_comments = posts(:one).comments
    assert_equal post_comments[0], comments(:one)
  end

  test "Get's posts direct comments" do
    post_comments = posts(:one).direct_comments
    assert_equal post_comments.size, 1
  end
end
