require "application_system_test_case"

class FollowshipsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "visiting index" do
    sign_in users(:three)

    visit post_url(posts(:one).id)

    assert_selector "div", text: "MyTextA"

    assert_selector "div", text: "MyStringA"

    click_button "like-button-post-#{posts(:one).id}"

    click_button "like-button-comment-#{comments(:one).id}"

    click_button "like-button-post-#{posts(:one).id}"

    click_button "like-button-comment-#{comments(:one).id}"

    assert_selector("button", minimum: 3, maximum: 3)
  end
end
