require "test_helper"

class FollowshipTest < ActiveSupport::TestCase
  test "Get User" do
    user = followships(:one).user
    assert_equal user, users(:one)
  end

  test "Get Follower" do
    follower = followships(:one).follower
    assert_equal follower, users(:three)
  end
end
