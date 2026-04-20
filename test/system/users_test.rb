require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "visiting show" do
    sign_in users(:three)

    visit user_url(users(:one).id)

    click_button "Stop Following"

    assert_selector "div", text: "Follow"

    click_button "Follow"

    assert_selector "div", text: "Cancel Request"

    click_button "Cancel Request"

    assert_selector "div", text: "Follow"
  end
end
