require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
 include Devise::Test::IntegrationHelpers
  test "visiting index" do
    sign_in users(:three)

    visit requests_path

    assert_selector "div", text: "Reject Request"

    click_button "Reject Request"

    assert_selector("button", minimum: 1, maximum: 1)
  end
  test "visiting sent" do
    sign_in users(:one)

    visit requests_sent_path

    assert_selector "div", text: "Cancel Request"

    click_button "Cancel Request"

    assert_selector("button", minimum: 1, maximum: 1)
  end
end
