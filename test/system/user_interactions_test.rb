require "application_system_test_case"

class UserInteractionsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  def setup
    @one = users(:one)
    @two   = users(:two)
    @three = users(:three)
    @four = users(:four)
  end

  test "real-time post creation/edit/destroy" do
    using_session("One") do
      sign_in @one
      visit root_path
    end

    using_session("Three") do
      sign_in @three
      visit root_path
    end

    using_session("One") do
      find("trix-editor").set("Hello Interaction")
      click_on "Post"
      assert_selector "div", text: "MyTextD"
      assert_selector "div", text: "Hello Interaction"
    end

    using_session("Three") do
      assert_selector "div", text: "MyTextD"
      assert_selector "div", text: "Hello Interaction"
    end

    using_session("One") do
      all(:button, "Edit", exact: true)[0].click
      all("trix-editor", minimum: 2)[1].set("Hello Again")

      click_on "Update"

      assert_selector "div", text: "MyTextD"
      assert_selector "div", text: "Hello Again"
    end

    using_session("Three") do
      assert_selector "div", text: "MyTextD"
      assert_selector "div", text: "Hello Again"
    end

    using_session("One") do
      all(:button, "X", exact: true, minimum: 2)[0].click

      assert_selector "div", text: "MyTextD"
      assert_no_selector "div", text: "Hello Again"
    end

    using_session("Three") do
      assert_selector "div", text: "MyTextD"
      assert_no_selector "div", text: "Hello Again"
    end
  end

  test "real-time comment creation/editing/delete on Post" do
    using_session("Three") do
      sign_in @three
      visit post_url(posts(:one).id)
    end

    using_session("One") do
      sign_in @one
      visit post_url(posts(:one).id)
    end

    using_session("Three") do
      fill_in "comment[content]", with: "Hello Interaction"

      click_on "Create"

      assert_selector "div", text: "Hello Interaction"
    end

    using_session("One") do
      assert_selector "div", text: "Hello Interaction"
    end

    using_session("Three") do
      click_on "Edit"

      all(:field, "comment[content]", minimum: 2)[1].set("Hello Again")

      click_on "Update"

      assert_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_selector "div", text: "Hello Again"
    end

    using_session("Three") do
      click_on "X"

      assert_no_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_no_selector "div", text: "Hello Again"
    end
  end

  test "real-time comment creation/editing/delete on Comment" do
    using_session("Three") do
      sign_in @three
      visit comment_url(comments(:two).id)
    end

    using_session("One") do
      sign_in @one
      visit comment_url(comments(:two).id)
    end

    using_session("Three") do
      fill_in "comment[content]", with: "Hello Interaction"

      click_on "Create"

      assert_selector "div", text: "Hello Interaction"
    end

    using_session("One") do
      assert_selector "div", text: "Hello Interaction"
    end

    using_session("Three") do
      click_on "Edit"

      all(:field, "comment[content]", minimum: 2)[1].set("Hello Again")

      click_on "Update"

      assert_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_selector "div", text: "Hello Again"
    end

    using_session("Three") do
      click_on "X"

      assert_no_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_no_selector "div", text: "Hello Again"
    end
  end

  test "real-time comment creation/editing/delete on Comment in Post Page" do
    using_session("Three") do
      sign_in @three
      visit post_url(posts(:one).id)
    end

    using_session("One") do
      sign_in @one
      visit post_url(posts(:one).id)
    end

    using_session("Three") do
      all(:button, "Respond", exact: true)[0].click

      all(:field, "comment[content]", minimum: 2)[1].set("Hello Interaction")

      all(:button, "Create", exact: true)[0].click

      all(:button, "Show Comments", exact: true)[0].click

      assert_selector "div", text: "Hello Interaction"
    end

    using_session("One") do
      all(:button, "Show Comments", exact: true)[0].click

      assert_selector "div", text: "Hello Interaction"
    end

    using_session("Three") do
      click_on "Edit"

      all(:field, "comment[content]", minimum: 2)[1].set("Hello Again")

      click_on "Update"

      assert_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_selector "div", text: "Hello Again"
    end

    using_session("Three") do
      click_on "X"

      assert_no_selector "div", text: "Hello Again"
    end

    using_session("One") do
      assert_no_selector "div", text: "Hello Again"
    end
  end

  test "Requests and Followships Interaction" do
    using_session("Two") do
      sign_in @two
      visit user_path(users(:four))
    end

    using_session("Two Sent") do
      sign_in @two
      visit requests_sent_path
    end

    using_session("Two Follows") do
      sign_in @two
      visit followships_path
    end

    using_session("Four") do
      sign_in @four
      visit requests_path
    end

    using_session("Four Followers") do
      sign_in @four
      visit followships_followers_path
    end

    using_session("Two") do
      click_on "Follow"

      assert_selector "div", text: "Cancel Request"
    end

    using_session("Four") do
      assert_selector "div", text: users(:two).username
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"
    end

    using_session("Two") do
      click_on "Cancel Request"

      assert_selector "div", exact_text: "Follow"
    end

    using_session("Four") do
      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"

      click_on "Cancel Request"

      assert_no_selector "div", text: users(:four).username
      assert_no_selector "div", exact_text: "follow"
    end

    using_session("Two") do
      click_on "Follow"

      assert_selector "div", text: "Cancel Request"
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"
    end

    using_session("Four") do
      assert_selector "div", text: users(:two).username

      click_on "Reject Request"

      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two") do
      assert_selector "div", exact_text: "Follow"
    end

    using_session("Two Sent") do
      assert_no_selector "div", text: users(:four).username
      assert_no_selector "div", exact_text: "follow"
    end

    using_session("Two") do
      click_on "Follow"

      assert_selector "div", text: "Cancel Request"
    end

    using_session("Four") do
      assert_selector "div", text: users(:two).username
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"

      click_on "Cancel Request"

      assert_no_selector "div", text: users(:four).username
      assert_no_selector "div", exact_text: "follow"
    end

    using_session("Four") do
      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two") do
      assert_selector "div", text: "Cancel Request"

      click_on "Cancel Request"

      assert_selector "div", exact_text: "Follow"
    end

    using_session("Two") do
      click_on "Follow"

      assert_selector "div", text: "Cancel Request"
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"
    end

    using_session("Four") do
      assert_selector "div", text: users(:two).username

      click_on "Accept Request"

      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two Sent") do
      assert_no_selector "div", text: users(:four).username
      assert_no_selector "div", exact_text: "follow"
    end

    using_session("Two Follows") do
      assert_selector "div", text: users(:four).username
    end

    using_session("Two") do
      assert_selector "div", text: "Stop Following"
    end

    using_session("Four Followers") do
      assert_selector "div", text: users(:two).username
    end

    using_session("Two Follows") do
      click_on "Stop Following"

      assert_no_selector "div", text: users(:four).username
    end

    using_session("Four Followers") do
      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two") do
      assert_selector "div", text: "Stop Following"

      click_on "Stop Following"

      assert_selector "div", exact_text: "Follow"
    end

    using_session("Two") do
      click_on "Follow"

      assert_selector "div", text: "Cancel Request"
    end

    using_session("Two Sent") do
      assert_selector "div", text: users(:four).username
      assert_selector "div", exact_text: "follow"
    end

    using_session("Four") do
      assert_selector "div", text: users(:two).username

      click_on "Accept Request"

      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two Sent") do
      assert_no_selector "div", text: users(:four).username
      assert_no_selector "div", exact_text: "follow"
    end

    using_session("Two Follows") do
      assert_selector "div", text: users(:four).username
    end

    using_session("Two") do
      assert_selector "div", text: "Stop Following"
    end

    using_session("Four Followers") do
      assert_selector "div", text: users(:two).username
    end

    using_session("Two") do
      click_on "Stop Following"

      assert_selector "div", exact_text: "Follow"
    end

    using_session("Four Followers") do
      assert_no_selector "div", text: users(:two).username
    end

    using_session("Two Follows") do
      assert_selector "div", text: users(:four).username

      click_on "Stop Following"

      assert_no_selector "div", text: users(:four).username
    end
  end
end
