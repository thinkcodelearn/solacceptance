require 'bundler/setup'
require 'capybara/cucumber'

PORT=54101

Capybara.default_driver = :selenium
Capybara.app_host = "http://localhost:#{PORT}"
Capybara.run_server = false


