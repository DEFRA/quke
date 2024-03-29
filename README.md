<img src="/quke.png" alt="Quke logo" />

![Build Status](https://github.com/DEFRA/quke/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_quke&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_quke)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_quke&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_quke)
[![Gem Version](https://badge.fury.io/rb/quke.svg)](https://badge.fury.io/rb/quke)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Quke is a gem that helps you to build a suite of [Cucumber](https://cucumber.io/) acceptance tests.

Quke tries to simplify the process of writing and running these tests by setting up **Cucumber** for you. It handles the config to allow you to run them in [Firefox](https://www.mozilla.org/en-GB/firefox/new/) (via Selenium) and [Chrome](https://www.google.co.uk/chrome/browser/desktop/) via [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb). It also has out of the box support for using [Browserstack automate](https://www.browserstack.com). This leaves you to focus on just your tests.

It was born out of trying to make the process for team members without a development background as simple as possible, and to get them involved in writing and building acceptance tests that they then manage.

It also includes the ability to run those tests using **Browserstack**. **Browserstack** gives you the ability to test your application with different combinations of platform, OS, and browser all in the cloud.

## Pre-requisites

You'll need [Ruby](https://www.ruby-lang.org/en/) installed (ideally the latest version available) plus the [Bundler](http://bundler.io/) gem.

The only other dependency this project has is the browsers you intend to use it with. It is currently setup to work with

- [Chrome](https://www.google.co.uk/chrome/browser/desktop/) (via [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb))
- [Firefox](https://www.mozilla.org/en-GB/firefox/new/) (via Selenium)

## Installation

Add this line to your application's Gemfile

```ruby
gem 'quke'
```

And then execute:

    $ bundle

Or install it yourself as

    $ gem install quke

## Configuration

You can configure Quke using a `.config.yml` file. What can be configured essentially falls into one of 3 groups.

- **Quke configuration** - things like which driver to use, whether to pause between steps, or if Quke should stop in the event of an error
- **Custom configuration** - add your own custom values using the `custom:` node
- **Browserstack configuration** - specify exactly how you want your Browserstack session to run, for example which browser and OS to test against, the project name, and your credentials.

See [.config.example.yml](.config.example.yml) for full details of the options you can specify in your `.config.yml`.

### Multiple configs

When Quke runs it will default to looking for `.config.yml`. However you can override this and tell Quke which one to use. This allows you to create multiple config files.

You do this using an environment variable. The most flexible way is to set the variable as part of your command.

```bash
QUKE_CONFIG='chrome.config.yml' bundle exec quke
```

The use case is to allow you to have different configs setup ready to go, and enable you to switch between them. For example when testing with Chrome and Firefox you set a 1 second delay between steps so you can observe the tests as they run through, but in your default `.config.yml` you want no pauses.

### Security

If you are testing a site that requires some form of login, or you are using **Browserstack** you'll need to tell Quke about the credentials. Generally we advise not committing your `.config.yml` to source control, but we understand you may well build up a suite of them that you want to store with the project and share with others.

If that's the case make use of the following features.

#### Browserstack environment variables

[.config.example.yml](.config.example.yml) is an example of a config file which contains `username`, `auth_key`, and if local testing `local_key`. You really don't want these becoming known so if you have to commit the config file, remove them and instead set the following environment variables wherever you need to run the tests.

- BROWSERSTACK_USERNAME
- BROWSERSTACK_AUTH_KEY
- BROWSERSTACK_LOCAL_KEY

Quke looks for them when configuring the **Browserstack** driver and only if not found does it then go looking in the config file.

#### Ruby's ENV classs

You can access any environment variable from within your project using [ENV](https://ruby-doc.org/core-2.4.2/ENV.html).

```ruby
secret_key = ENV['SUPER_SECRET_KEY']
```

You can set them by calling `export SUPER_SECRET_KEY="password123"` in your terminal prior to running Quke. In this way for example, the passwords featured in the custom section in [.config.example.yml](.config.example.yml) could be removed, and instead your step could read the value it needs to submit from an environment variable.

## Usage

TODO: Write usage instructions here

## Behaviours

You should be aware of some default behaviours included in Quke.

### Displaying web pages on fail

Capybara includes the ability to save the source of the current page at any point. Quke has been configured so that if you are not using a headless browser and a step fails it will save the source to file and then use a tool called [Launchy](https://github.com/copiousfreetime/launchy) to open it in your default browser.

You can disable this behaviour using `display_failures: false` in your `.config.yml`

### Quit on 5 failures

If you are running using Chrome or Firefox after the 5th failure Quke will automatically stop. This is to prevent scores of tabs being opened in the browser when an error is found and Quke is set to show failures, which may just be the result of an error in the test code.

### Automatically setting Browserstack session status

If you are using the Browserstack driver, Quke will automatically update the status of the session recorded in Browserstack for you. If all tests pass, it will be marked as 'passed', else it will be marked as 'failed' (it defaults to 'completed').

## Browser drivers

A very simple overview of how things work is that

- [Cucumber](https://github.com/cucumber/cucumber-ruby) runs the tests
- [Capbybara](https://github.com/teamcapybara/capybara) is used in the tests to simplify working with Selenium
- [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb) is used to tell the browsers what to do
- each browser has a driver ([Chromedriver](https://chromedriver.chromium.org/), [Geckodriver](https://github.com/mozilla/geckodriver) etc) which can interpret Selenium commands into actual actions


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Running

Whilst just developing a gem like Quke you can execute it with

    $ ruby -Ilib ./exe/quke

and pass in arguments as well

    $ ruby -Ilib ./exe/quke --tags @wip

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
