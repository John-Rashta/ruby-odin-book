require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "creating a post" do
      sign_in users(:three)

      visit root_url

      connect_turbo_cable_stream_sources

      assert_button "Post", disabled: :all

      find("trix-editor").set("Hello World")

      click_on "Post"

      sleep 1

      assert_selector "div", text: "Hello World"

      assert_selector "div", text: "Sucessfully created post!"
  end

  test "clicking on post content to go to show page" do
    sign_in users(:three)

    visit root_url

    click_on "MyTextB"

    assert_selector "div", text: "MyTextB"

    assert_selector "div", text: "MyStringB"
  end
end
