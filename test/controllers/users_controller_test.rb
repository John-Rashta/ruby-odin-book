require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Show View" do
    sign_in users(:three)
    get user_url(users(:one).id)
    assert_dom "div", "David"
    assert_dom "div", "MyTextD"
    assert_dom "div", "0"
  end

   test "Index View" do
    sign_in users(:one)
    get users_url
    assert_dom "div", "John"
    assert_dom "div", "Sent"
    assert_dom "div", "Sarah"
    assert_dom "div", "Jenny"
  end
end
