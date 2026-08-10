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

  test "clicking to delete post" do
    sign_in users(:three)

    visit root_url

    click_on "X"

    assert_no_selector "div", text: "MyTextB"
  end

  test "editing post" do
    sign_in users(:three)

    visit root_url

    all(:button, "Edit", exact: true)[0].click

    all("trix-editor", minimum: 2)[1].set("Hello Ruby")

    click_on "Update"

    assert_selector "div", text: "Hello Ruby"
  end
end
