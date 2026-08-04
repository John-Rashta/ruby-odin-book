require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "manually logging in" do
    visit new_user_session_path

    fill_in "Username", with: users(:three).username
    fill_in "Password", with: "ABCDE"
    click_on "Log in"

    assert_button "Post", disabled: :all

    assert_selector "a", text: "Followships"
  end

  test "clicking on username to go to show page" do
    sign_in users(:three)

    visit root_url

    click_on "Sarah"

    assert_selector "div", text: "Sarah"
  end
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

    test "visiting header links" do
      sign_in users(:three)

      visit root_url

      assert_button "Post", disabled: :all

      click_on "Followships"

      assert_selector "a", text: "Followers"

      click_on "Requests"

      assert_selector "a", text: "Sent Requests"

      click_on "Change Avatar"

      assert_button "Upload", disabled: :all

      click_on "Users"

      assert_selector "div", text: "John"

      click_on "Home"

      assert_button "Post", disabled: :all
    end
end
