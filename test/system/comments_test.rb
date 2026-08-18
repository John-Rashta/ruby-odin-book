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

      visit comment_url(comments(:one).id)

      connect_turbo_cable_stream_sources

      assert_button "Create", disabled: :all

      fill_in "comment[content]", with: "Hello World"

      click_on "Create"

      assert_selector "div", text: "Hello World"

      assert_selector "div", text: "Sucessfully created Comment!"
  end

  test "creating a comment on a comment in a post page" do
      user = users(:three)

      login_as(user, scope: :user)

      connect_turbo_cable_stream_sources

      visit comment_url(posts(:one).id)

      connect_turbo_cable_stream_sources

      assert_button "Create", disabled: :all

      click_on "Respond"

      all(:field, "comment[content]", minimum: 2)[1].set("Hello World")

      click_on "Create"

      click_on "Show Comments"

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

  test "clicking to delete comment in post" do
    user = users(:one)

    login_as(user, scope: :user)

    visit post_url(posts(:one).id)

    click_on "X"

    assert_no_selector "div", text: "MyStringA"
  end

  test "clicking to delete comment in comment" do
    user = users(:one)

    login_as(user, scope: :user)

    visit comment_url(comments(:one).id)

    all(:button, "X", exact: true, minimum: 2)[1].click

    assert_no_selector "div", text: "MyStringC"
  end

  test "clicking to delete comment of comment in a post show page" do
    user = users(:one)

    login_as(user, scope: :user)

    visit post_url(posts(:one).id)

    click_on "Show Comments"

    all(:button, "X", exact: true, minimum: 2)[1].click

    assert_no_selector "div", text: "MyStringC"
  end

  test "editing comment in post" do
    user = users(:one)

    login_as(user, scope: :user)

    visit post_url(posts(:one).id)

    click_on "Edit"

    all(:field, "comment[content]", minimum: 2)[1].set("Hello Ruby")

    click_on "Update"

    assert_selector "div", text: "Hello Ruby"
  end

  test "editing comment in comment" do
    user = users(:one)

    login_as(user, scope: :user)

    visit comment_url(comments(:one).id)

    all(:button, "Edit", exact: true, minimum: 2)[1].click

    all(:field, "comment[content]", minimum: 2)[1].set("Hello Ruby")

    click_on "Update"

    assert_selector "div", text: "Hello Ruby"
  end

  test "editing comment of comment in a post show page" do
    user = users(:one)

    login_as(user, scope: :user)

    visit post_url(posts(:one).id)

    click_on "Show Comments"

    all(:button, "Edit", exact: true, minimum: 2)[1].click

    all(:field, "comment[content]", minimum: 2)[1].set("Hello Ruby")

    click_on "Update"

    assert_selector "div", text: "Hello Ruby"
  end
end
