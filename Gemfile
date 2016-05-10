source 'https://rubygems.org'

# We need the cucumber gem to create cucumber feature tests, obviously!
gem 'cucumber'

# We use capybara to drive whichever browser we are using, and by drive we mean
# things like fill_in x, click_on y etc. Capybara makes it much easier to do
# this, though if you're willing to go a level lower you can write your own code
# to tell selenium how to interact with a web page
gem 'capybara'

# We bring in rspec-expectations to simplify how we actually test if a page is
# correct. For example we can test we are on the right page in a step using
# expect(page).to have_text 'Welcome to test nirvana!'
gem 'rspec-expectations'

# This is the first of our web drivers i.e. the bits that allow capybara to
# to drive an actual browser. Poltergeist is used with a headless browser
# called phantomjs, which is superfast and great for using on CI servers
# as it has no other dependencies
gem 'poltergeist'

# selenium-webdriver is used to actual drive real browsers you have installed,
# for example Firefox, Chrome and Internet Explorer. The benefit of selenium
# is you can actually see the tests interacting with the browser, but this of
# course means they run slower and isn't suitable for a CI environment.
gem 'selenium-webdriver'

# Needed when wishing to use Chrome for selenium tests. We could have chosen to
# install the chromedriver separately (and it seems more recent tutorials do it
# in that way). However in an effort to make using this project as simple as
# possible we have gone with using the chromedriver-helper. To quote from it
# "Easy installation and use of chromedriver, the Chromium project's selenium
# webdriver adapter."
gem 'chromedriver-helper'

# Experience has shown that keeping our tests dry helps make them more
# maintainable over time. A critical aspect in doing this is the use of the page
# object pattern. A page object wraps up all functionality for describing and
# interacting with a page into a single object. This object can then be
# referred to in the steps, rather than risk duplicating the logic in different
# steps
gem 'site_prism'

# Rake gives us the ability to create our own commands or 'tasks' for working
# with quke. We add a gemfile to the project and our custom tasks and users
# can now for example the tests using the Chrome browser by simply typing
# rake chrome. Check the Rakefile itself for further details.
gem 'rake'

# Capybara includes a method called save_and_open_page. Without launchy it
# will still save to file a copy of the source html of the page in question
# at that time. However simply adding this line into the gemfile means it
# will instead open in the default browser instead.
gem 'launchy'
