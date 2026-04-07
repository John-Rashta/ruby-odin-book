require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    # Create the email and store it for further assertions
    email = UserMailer.welcome_email(users(:one))

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal [ "welcome@example.com" ], email.from
    assert_equal [ "david@rails" ], email.to
    assert_equal "Welcome To Odin Book!", email.subject
    assert_equal read_fixture("welcome.txt").join, email.text_part.body.to_s
    assert_equal read_fixture("welcome_html.txt").join, email.html_part.body.to_s
  end
end
