require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "Get's Requests" do
    user_requests = users(:one).requests
    assert_equal user_requests[0], requests(:two)
  end

  test "Get's Sent Requests" do
    user_sent_requests = users(:one).sent_requests
    assert_equal user_sent_requests[0], requests(:three)
  end

  test "Get's Followships" do
    user_followships = users(:one).followships
    assert_equal user_followships[0], followships(:one)
  end

  test "Get's Inverse Followships" do
    user_inverse_followships = users(:three).inverse_followships
    assert_equal user_inverse_followships[0], followships(:one)
  end

  test "Get's Followers" do
    user_followers = users(:one).followers
    assert_equal user_followers[0], users(:three)
  end

  test "Get's Followings" do
    user_followings = users(:three).followings
    assert_equal user_followings[0], users(:one)
  end

  test "Get's Created Posts" do
    user_posts = users(:two).created_posts
    assert_equal user_posts[0], posts(:one)
  end

  test "Get's Created Comments" do
    user_comments = users(:two).created_comments
    assert_equal user_comments[0], comments(:two)
  end

  test "Get's Likes" do
    user_likes = users(:one).likes
    assert_equal user_likes[0], likes(:one)
  end

  test "Get's Liked Posts" do
    user_liked_posts = users(:one).liked_posts
    assert_equal user_liked_posts[0], posts(:one)
  end

  test "Get's Liked Comments" do
    user_liked_comments = users(:one).liked_comments
    assert_equal user_liked_comments[0], comments(:two)
  end

  test "Get's if Followed by Current User" do
    Current.current_user_id = users(:three).id
    current_user_followship = users(:one).followed
    assert_equal current_user_followship[0], followships(:one)
  end

  test "Get's Nothing if not Followed" do
    Current.current_user_id = users(:two).id
    current_user_followship = users(:one).followed
    assert_nil current_user_followship[0]
  end

  test "Get's currently sent requests to user" do
    Current.current_user_id = users(:four).id
    current_user_sent_requests = users(:one).received_by_current
    assert_equal current_user_sent_requests[0], requests(:two)
  end

   test "Get's nothing if no sent requests" do
    Current.current_user_id = users(:three).id
    current_user_sent_requests = users(:one).received_by_current
    assert_nil current_user_sent_requests[0]
  end
end
