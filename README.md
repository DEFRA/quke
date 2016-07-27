<img src="/config/quke.png" alt="Git flow" />

[![Build Status](https://travis-ci.org/EnvironmentAgency/quke.svg?branch=master)](https://travis-ci.org/EnvironmentAgency/quke)
[![security](https://hakiri.io/github/EnvironmentAgency/quke/master.svg)](https://hakiri.io/github/EnvironmentAgency/quke/master)
[![Code Climate](https://codeclimate.com/github/EnvironmentAgency/quke/badges/gpa.svg)](https://codeclimate.com/github/EnvironmentAgency/quke)
[![Dependency Status](https://dependencyci.com/github/EnvironmentAgency/quke/badge)](https://dependencyci.com/github/EnvironmentAgency/quke)

Quke is a template repo for building [Cucumber](https://cucumber.io/) feature tests that can be run against a web site. Unlike normal Ruby/Rails setups the feature tests do not need to be included with the source code for the site to be tested. Instead this template project provides the ability to run them standalone.

The intention is to give members of a team responsible for Quality Assurance/Test the flexibility to create, manage and run their tests separately.

It also includes the ability to run those tests using [Browserstack](https://www.browserstack.com). Browserstack gives you the ability to test your application with different combinations of platform, OS, and browser all in the cloud.

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

## Intended workflow

As Quke is intended to provide a minimum template for your test suite we recommend you start by [forking the project](https://help.github.com/articles/fork-a-repo/).

This will result in a new repository against your GitHub user called Quke which you'll download to your local machine using

```bash
git clone https://github.com/your-username/quke.git
```

You can then add tests specific to the project you wish to test, but keep the underlying Quke functionality in sync with the main project. We've tried to ensure there will be no [merge](https://en.wikipedia.org/wiki/Merge_(version_control)) conflicts by keeping all Quke specific content in separate folders or by using `Quke` in the names used.

So in summary when starting a new project

- Fork [Quke](https://github.com/EnvironmentAgency/quke) and clone locally
- Setup local project for [synching](https://help.github.com/articles/fork-a-repo/#step-3-configure-git-to-sync-your-fork-with-the-original-spoon-knife-repository) with Quke
- Complete [Installation](#installation)
- Write tests
- [Sync](https://help.github.com/articles/syncing-a-fork/) periodically

## Installation

The project will need to have been copied to your local machine first. You can do this using the [intended workflow](#intended-workflow) or simply by cloning the project

```bash
git clone https://github.com/EnvironmentAgency/quke.git
```

This will create a folder named `quke`. Navigate to that folder `cd quke` and then run the following command.

```bash
bundle install --without development
```

[Bundler](http://bundler.io/) will download everything needed for the project. Once complete you're good to go!

### --without development

If you are working on Quke itself there are additional bits required to aid with that. These are grouped under `development` and will be installed if you just run `bundle install`. As they are not needed if you are just writing tests we advise you to use the `--without development` flag.

## Execution

Quke comes with some inbuilt commands which provide a shorthand for the most common use cases.

- `bundle exec rake`
  - This will run Quke using its default browser choice (PhantomJS)
- ` bundle exec rake chrome`
  - This will run Quke using Chrome
- ` bundle exec rake firefox`
  - This will run Quke using Firefox
- ` bundle exec rake browserstack`
  - This will run Quke using using Browserstack's [automate](https://www.browserstack.com/automate) feature (you must have provided a username and authorisation key as a minimum)

If you want more control and access to all the options available to cucumber (see the full list with `bundle exec cucumber --help`) run Quke using

```bash
bundle exec cucumber
```

### Why `bundle exec`?

Using `bundle exec` at the start of each command is to ensure we are using the version of a *thing* that was installed as part of Quke, for example Cucumber or [Rake](https://github.com/ruby/rake). While a command may work without it, doing so is unreliable and should be avoided.

## Configuration

The alternative to using the built in rake commands is to use configuration to drive Quke. You can configure Quke using `.config.yml` files.

### Options

Quke recognises 3 main options

- **app_host** - Set the root url. You can then use it directly using Capybara with `visit('/Main_Page')` or `visit('/')` rather than having to repeat the full url each time
- **driver** - Tell Quke which browser to use for testing. Options are *chrome*, *firefox*, *browserstack*, and *phantomjs* (*phantomjs* is the default)
- **pause** - Add a pause (in seconds) between steps so you can visually track how the browser is responding. The default is *0*

For example

```yaml
app_host: 'https://en.wikipedia.org/wiki'
driver: chrome
pause: 1
```

If using Browserstack there is an additional block of config to add. As a minimum its must contain `username:` and `auth_key:`.

```yaml
app_host: 'https://en.wikipedia.org/wiki'
driver: chrome
pause: 1
browserstack:
  username: johndoe
  auth_key: iTsFRi4AYfRi4AYTALKi
```
See [.config.example.yml](/.config.example.yml) for more details and examples.

#### Environment variables

You can also set the main options (including Browserstack username and authorisation key) using environment variables. This might be useful should you wish to add your tests to a CI build and keep your browserstack credentials protected. Options that can be set by environment variable are

- APP_HOST
- DRIVER
- PAUSE
- BROWSERSTACK_USERNAME
- BROWSERSTACK_AUTH_KEY

### Multiple configs

When Quke runs it will default to looking for `.config.yml`. However you can override this and tell Quke which one to use. This allows you to create multiple config files.

You do this using an environment variable. The most flexible way is to set the variable as part of your command.

```bash
QCONFIG='chrome.config.yml' bundle exec cucumber
```

The use case is to allow you to have different configs setup ready to go, and enable you to switch between them. For example when testing with Chrome and Firefox you also want a 1 second delay between steps so you can observe the tests as they run through, but in your default you want no pauses.

## Confirming it works

Included in Quke are some feature tests which can be used for reference, but also to confirm you have it setup and working correctly. They run against an internal demo web app which you'll need to start before executing the tests.

```bash
bundle exec rake run
```

*N.B. You're best off running this in a separate terminal window.*

Having completed [installation](#installation) and got the demo app running, calling `bundle exec cucumber` should return the following

```bash
Using the default profile...
0 scenarios
0 steps
0m0.000s
```

You can then run the included tests with `bundle exec cucumber -p quke` (or use the built in command `bundle exec rake check_quke`) and should see successful output from each of the tests plus an updated summary.

You can also test Browserstack integration using `bundle exec cucumber -p quke_browserstack` or (`bundle exec rake check_browserstack`), but you must set the user name and password first.

## Behaviours

You should be aware of some default behaviours included in Quke.

### Displaying web pages on fail

Capybara includes the ability to save the source of the current page at any point. Quke has been configured so that if you are not using a headless browser and a step should fail it will save the source to file and then use a tool called [Launchy](https://github.com/copiousfreetime/launchy) to open it in your default browser.

### Early fail for CI

When running using the default PhantomJS headless browser, as soon as there is a failure Quke will exit. This is because it is assumed when used in headless mode the key thing to know is *are there any failures*, to ensure fast feedback from your CI build server.

### Quit on 5 failures

If you are running using Chrome or Firefox after the 5th failure Quke will automatically close Cucumber. This is to prevent scores of tabs being opened in the browser when an error is found, which may just be the result of an error in the test code.

### Change to the default Cucumber profile

Cucumber has the ability to create [custom profiles](https://github.com/cucumber/cucumber/wiki/cucumber.yml). A profile is simply a way to alias a call to Cucumber, with all your arguments already set.

Running `bundle exec cucumber -p quke` will run 1 such profile, which runs only those scenarios flagged with the `@quke` tag.

Quke has also tweaked the default profile to ensure any scenarios flagged with the `@quke` tag are not run when `bundle exec cucumber` is called.

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
