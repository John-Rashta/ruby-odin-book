require "test_helper"

class RequestTest < ActiveSupport::TestCase
  test "Get User" do
    user = requests(:one).user
    assert_equal user, users(:three)
  end

  test "Get Sender" do
    sender = requests(:one).sender
    assert_equal sender, users(:four)
  end
end
