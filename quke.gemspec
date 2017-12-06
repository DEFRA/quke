lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quke/version'

# Don't believe you would want to break this particular block up hence adding
# the exception for rubocop.
# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'quke'
  spec.version       = Quke::VERSION
  spec.authors       = ['Alan Cruikshanks']
  spec.email         = ['alan.cruikshanks@environment-agency.gov.uk']

  spec.summary       = 'A gem to simplify creating acceptance tests using Cucumber'
  # My attempts to break this line up to meet the 120 char limit we have set
  # have proved fruitles so far!
  # rubocop:disable Metrics/LineLength
  spec.description   = 'Quke tries to simplify the process of writing and running acceptance tests by setting up Cucumber for you. It handles the config to allow you to run your tests in Firefox and Chrome, or the headless browser PhantomJS. It also has out of the box setup for using Browserstack automate. This leaves you to focus on just your features and steps.'
  # rubocop:enable Metrics/LineLength
  spec.homepage      = 'https://github.com/DEFRA/quke'
  spec.license       = 'Nonstandard'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect /
           against public gem pushes.'
  end

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9'

  # We need the cucumber gem to use cucumber, obviously!
  spec.add_dependency 'cucumber', '~> 2.4'

  # We use capybara to drive whichever browser we are using, and by drive we
  # mean things like fill_in x, click_on y etc. Capybara makes it much easier to
  # do this, though if you're willing to go a level lower you can write your own
  # code to tell selenium how to interact with a web page
  spec.add_dependency 'capybara', '~> 2.9'

  # We bring in rspec-expectations to simplify how to actually test if a page is
  # correct. For example you can test you are on the right page in a step using
  # expect(page).to have_text 'Welcome to test nirvana!'
  spec.add_dependency 'rspec-expectations', '~> 3.4'

  # This is the first of our web drivers i.e. the bits that allow capybara to
  # to drive an actual browser. Poltergeist is used with a headless browser
  # called phantomjs, which is superfast and great for using on CI servers
  # as it has no other dependencies
  spec.add_dependency 'poltergeist', '~> 1.10'

  # selenium-webdriver is used to drive real browsers that may be installed,
  # for example Firefox, Chrome and Internet Explorer. The benefit of selenium
  # is you can actually see the tests interacting with the browser, the downside
  # is they run slower and isn't best suited to a CI environment.
  spec.add_dependency 'selenium-webdriver', '~> 2.53'

  # Needed when wishing to use Chrome for selenium tests. We could have chosen
  # to install the chromedriver separately (and it seems more recent tutorials
  # do it in that way). However in an effort to make using this gem as simple
  # as possible we have gone with using the chromedriver-helper. To quote
  # from it "Easy installation and use of chromedriver, the Chromium project's
  # selenium webdriver adapter."
  spec.add_dependency 'chromedriver-helper', '~> 1.0'

  # Experience has shown that keeping tests dry helps make them more
  # maintainable over time. One practice that helps is the use of the
  # page object pattern. A page object wraps up all functionality for describing
  # and interacting with a page into a single object. This object can then be
  # referred to in the steps, rather than risk duplicating the logic in
  # different steps. Site_Prism provides a page object framework, and we build
  # it into the gem so users of Quke don't have to add and setup this dependency
  # themselves
  spec.add_dependency 'site_prism', '~> 2.9'

  # Capybara includes a method called save_and_open_page. Without Launchy it
  # will still save to file a copy of the source html of the page in question
  # at that time. However simply adding this line into the gemfile means it
  # will instead open in the default browser instead.
  spec.add_dependency 'launchy', '~> 2.4'

  # Ruby bindings for BrowserStack Local. This gem handles downloading and
  # installing the right version of the binary for the OS Quke is running on,
  # and provides an API for managing it.
  spec.add_dependency 'browserstack-local'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.6'
  spec.add_development_dependency 'github_changelog_generator', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'rdoc', '~> 4.2'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'simplecov', '~> 0.12'
end
# rubocop:enable Metrics/BlockLength
