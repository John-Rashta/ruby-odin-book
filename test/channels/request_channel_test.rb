require "test_helper"

class RequestChannelTest < ActionCable::Channel::TestCase
  test "subscribes and stream for user" do
    stub_connection current_user: users(:one)

    subscribe

    assert_has_stream_for users(:one)
  end
end
