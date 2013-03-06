When(/^I visit the front page$/) do
  visit '/'
end

Then(/^I should see the site$/) do
  page.should have_content("hello")
end
