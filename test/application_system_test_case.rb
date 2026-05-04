require "test_helper"
WINDOWS_HOST = `cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }'`.strip
# STILL HAVENT FIGURED OUT HOW TO SET THE DRIVER PORT- IT RANDOMIZES EVERY TIME
CHROMEDRIVER_URL = "http://#{WINDOWS_HOST}:52341/"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  driven_by :selenium_remote_chrome
  Capybara.register_driver :selenium_remote_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--start-maximized")

    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: CHROMEDRIVER_URL,
      options: options
    )
  end

  Capybara.configure do |config|
    # Match what's set for URL options in test.rb so we
    # can test mailers that contain links.
    config.test_id = "data-testid"
    config.server_host = "localhost"
    config.server_port = "3000"
  end
end
