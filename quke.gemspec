# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "quke/version"

Gem::Specification.new do |spec|
  spec.name          = "quke"
  spec.version       = Quke::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["alan.cruikshanks@environment-agency.gov.uk"]
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.homepage      = "https://github.com/DEFRA/quke"
  spec.summary       = "A gem to simplify creating acceptance tests using Cucumber"
  # My attempts to break this line up to meet the 120 char limit we have set
  # have proved fruitles so far!
  # rubocop:disable Layout/LineLength
  spec.description   = "Quke tries to simplify the process of writing and running acceptance tests by setting up Cucumber for you. It handles the config to allow you to run your tests in Firefox or Chrome. It also has out of the box setup for using Browserstack automate. This leaves you to focus on just your features and steps."
  # rubocop:enable Layout/LineLength

  spec.files = Dir["{bin,exe,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  spec.required_ruby_version = ">= 2.4"

  # We need the cucumber gem to use cucumber, obviously!
  spec.add_dependency "cucumber", "~> 3.1"

  # We use capybara to drive whichever browser we are using, and by drive we
  # mean things like fill_in x, click_on y etc. Capybara makes it much easier to
  # do this, though if you're willing to go a level lower you can write your own
  # code to tell selenium how to interact with a web page
  spec.add_dependency "capybara", "~> 3.14"

  # We bring in rspec-expectations to simplify how to actually test if a page is
  # correct. For example you can test you are on the right page in a step using
  # expect(page).to have_text 'Welcome to test nirvana!'
  spec.add_dependency "rspec-expectations", "~> 3.8"

  # selenium-webdriver is used to drive browsers like Firefox, Chrome and
  # Internet Explorer.
  spec.add_dependency "selenium-webdriver", "~> 4.1"

  # Experience has shown that keeping tests dry helps make them more
  # maintainable over time. One practice that helps is the use of the
  # page object pattern. A page object wraps up all functionality for describing
  # and interacting with a page into a single object. This object can then be
  # referred to in the steps, rather than risk duplicating the logic in
  # different steps. Site_Prism provides a page object framework, and we build
  # it into the gem so users of Quke don't have to add and setup this dependency
  # themselves
  spec.add_dependency "site_prism", "~> 3.0"

  # Capybara includes a method called save_and_open_page. Without Launchy it
  # will still save to file a copy of the source html of the page in question
  # at that time. However simply adding this line into the gemfile means it
  # will instead open in the default browser instead.
  spec.add_dependency "launchy", "~> 2.4"

  # Ruby bindings for BrowserStack Local. This gem handles downloading and
  # installing the right version of the binary for the OS Quke is running on,
  # and provides an API for managing it.
  spec.add_dependency "browserstack-local"

  spec.add_development_dependency "defra_ruby_style"
  spec.add_development_dependency "github_changelog_generator"
  # Adds step-by-step debugging and stack navigation capabilities to pry using
  # byebug
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_development_dependency "webmock", "~> 3.5"
  spec.metadata["rubygems_mfa_required"] = "true"
end
