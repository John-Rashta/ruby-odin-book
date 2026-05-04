require "application_system_test_case"

class LikesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "visiting index" do
    sign_in users(:three)

    visit followships_path

    assert_selector "div", text: "Stop Following"

    click_button "Stop Following"

    assert_selector("button", minimum: 1, maximum: 1)
  end
end
