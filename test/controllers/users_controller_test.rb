require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "Get Show" do
    sign_in users(:three)
    get user_url(users(:one).id)
    assert_response :success
  end

  test "Get Index" do
    sign_in users(:one)
    get users_url
    assert_response :success
  end

  test "Show View" do
    sign_in users(:three)
    get user_url(users(:one).id)
    assert_dom "div", "David"
    assert_dom "div", "MyTextD"
    assert_dom "div", "0"
    assert_dom "button", "Stop Following"
  end

  test "Index View" do
    sign_in users(:one)
    get users_url
    assert_dom "div", "John"
    assert_dom "button", "Cancel Request"
    assert_dom "div", "Sarah"
    assert_dom "div", "Jenny"
  end

  test "Sign Up Email" do
    # Asserts the difference in the ActionMailer::Base.deliveries
    assert_emails 1 do
      post user_registration_url, params: { user: { "username" => "bbb", "email" => "ff@aa", "password" => "123456" } }
    end
  end
end
