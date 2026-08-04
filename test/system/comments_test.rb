require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  test "creating a comment on post" do
      user = users(:three)

      login_as(user, scope: :user)

      connect_turbo_cable_stream_sources

      visit post_url(posts(:one).id)

      connect_turbo_cable_stream_sources

      assert_button "Create", disabled: :all

      fill_in "comment[content]", with: "Hello World"

      click_on "Create"

      assert_selector "div", text: "Hello World"

      assert_selector "div", text: "Sucessfully created Comment!"
  end

   test "creating a comment on a comment" do
      user = users(:three)

      login_as(user, scope: :user)

      connect_turbo_cable_stream_sources

      visit post_url(comments(:one).id)

      connect_turbo_cable_stream_sources

      assert_button "Create", disabled: :all

      fill_in "comment[content]", with: "Hello World"

      click_on "Create"

      assert_selector "div", text: "Hello World"

      assert_selector "div", text: "Sucessfully created Comment!"
  end

  test "clicking on comment content to go to show page" do
    user = users(:three)

    login_as(user, scope: :user)

    visit post_url(posts(:one).id)

    click_on "MyStringA"

    assert_selector "div", text: "MyStringA"

    assert_selector "div", text: "MyStringC"
  end
end
