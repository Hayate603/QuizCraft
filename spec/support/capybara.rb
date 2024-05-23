Capybara.register_driver :selenium_chrome do |app|
  url = 'http://chrome:4444/wd/hub'
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1680,1050')
  
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: url,
    capabilities: [options]
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3001
    Capybara.app_host = "http://quizcraft:3001"
  end
end
