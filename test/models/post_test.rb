require "test_helper"

class PostTest < ActiveSupport::TestCase
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
end
