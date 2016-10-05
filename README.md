<img src="/quke.png" alt="Git flow" />

[![Build Status](https://travis-ci.org/EnvironmentAgency/quke.svg?branch=master)](https://travis-ci.org/EnvironmentAgency/quke)
[![security](https://hakiri.io/github/EnvironmentAgency/quke/master.svg)](https://hakiri.io/github/EnvironmentAgency/quke/master)
[![Code Climate](https://codeclimate.com/github/EnvironmentAgency/quke/badges/gpa.svg)](https://codeclimate.com/github/EnvironmentAgency/quke)
[![Test Coverage](https://codeclimate.com/github/EnvironmentAgency/quke/badges/coverage.svg)](https://codeclimate.com/github/EnvironmentAgency/quke/coverage)
[![Dependency Status](https://dependencyci.com/github/EnvironmentAgency/quke/badge)](https://dependencyci.com/github/EnvironmentAgency/quke)
[![Gem Version](https://badge.fury.io/rb/quke.svg)](https://badge.fury.io/rb/quke)

Quke is a gem that helps you to build a suite of [Cucumber](https://cucumber.io/) acceptance tests.

Quke tries to simplify the process of writing and running these tests by setting up **Cucumber** for you. It handles the config to allow you to run them in [Firefox](https://www.mozilla.org/en-GB/firefox/new/) (via Selenium) and [Chrome](https://www.google.co.uk/chrome/browser/desktop/) (via [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb)), or the headless browser [PhantomJS](http://phantomjs.org/) (via [Poltergeist](https://github.com/teampoltergeist/poltergeist)). It also has out of the box support for using [Browserstack automate](https://www.browserstack.com). This leaves you to focus on just your tests.

It was born out of trying to make the process for team members without a development background as simple as possible, and to get them involved in writing and building acceptance tests that they then manage.

It also includes the ability to run those tests using **Browserstack**. **Browserstack** gives you the ability to test your application with different combinations of platform, OS, and browser all in the cloud.

## Pre-requisites

You'll need [Ruby](https://www.ruby-lang.org/en/) installed (ideally the latest version available) plus the [Bundler](http://bundler.io/) gem.

The only other dependency this project has is the browsers you intend to use it with. It is currently setup to work with

- [PhantomJS](http://phantomjs.org/) (via [Poltergeist](https://github.com/teampoltergeist/poltergeist))
- [Chrome](https://www.google.co.uk/chrome/browser/desktop/) (via [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb))
- [Firefox](https://www.mozilla.org/en-GB/firefox/new/) (via Selenium)

The one you may not have heard of is **PhantomJS**. It is a [headless browser](https://en.wikipedia.org/wiki/Headless_browser).

> A headless browser is a web browser without a graphical user interface

Quke uses **PhantomJS** as its default browser. Using a headless browser the tests will run much faster and means Quke can also be used as part of your [CI build](https://en.wikipedia.org/wiki/Build_automation).

It is assumed you know what **Chrome** and **Firefox** are and how to install them.

### Install PhantomJS

#### Mac

We highly recommend using [Homebrew](http://brew.sh/) if you are using a **Mac** for installing packages like PhantomJS.

Once installed run `brew install phantomjs`

#### Linux

You'll need to

- Download either the 32bit or 64bit binary from <http://phantomjs.org/download.html>
- Extract the content and add the `bin/phantomjs` directory to your `PATH`

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

You can use configuration to drive Quke. You can configure Quke using `.config.yml` files. See [.config.example.yml](.config.example.yml) for details of the options to include in your `.config.yml`.

### Multiple configs

When Quke runs it will default to looking for `.config.yml`. However you can override this and tell Quke which one to use. This allows you to create multiple config files.

You do this using an environment variable. The most flexible way is to set the variable as part of your command.

```bash
QUKE_CONFIG='chrome.config.yml' bundle exec quke
```

The use case is to allow you to have different configs setup ready to go, and enable you to switch between them. For example when testing with Chrome and Firefox you set a 1 second delay between steps so you can observe the tests as they run through, but in your default `.config.yml` you want no pauses and use **phantomjs**.

## Usage

TODO: Write usage instructions here

## Behaviours

You should be aware of some default behaviours included in Quke.

### Displaying web pages on fail

Capybara includes the ability to save the source of the current page at any point. Quke has been configured so that if you are not using the headless browser and a step should fail it will save the source to file and then use a tool called [Launchy](https://github.com/copiousfreetime/launchy) to open it in your default browser.

### Early fail for CI

When running using the default PhantomJS headless browser, as soon as there is a failure Quke will exit. This is because it is assumed when used in headless mode the key thing to know is *are there any failures*, to ensure fast feedback from your CI build server.

### Quit on 5 failures

If you are running using Chrome or Firefox after the 5th failure Quke will automatically stop. This is to prevent scores of tabs being opened in the browser when an error is found, which may just be the result of an error in the test code.

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
