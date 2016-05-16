# Quke

A template repo for building [Cucumber](https://cucumber.io/) feature tests that can be run against a web site. Unlike normal setups the feature tests do not need to be included with the source code for the site to be tested. Instead this template project includes the ability to run them standalone.

The intention is to give members of a team responsible for Quality Assurance of a project the flexibility to create, manage and run their tests separately.

## Pre-requisites

You'll need [Ruby](https://www.ruby-lang.org/en/) installed (ideally the latest version available) plus the [Bundler](http://bundler.io/) gem.

The only other dependency this project has is the browsers you intend to use it with. It is currently setup to work with

- [PhantomJS](http://phantomjs.org/) (via [Poltergeist](https://github.com/teampoltergeist/poltergeist))
- [Chrome](https://www.google.co.uk/chrome/browser/desktop/) (via [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb))
- [Firefox](https://www.mozilla.org/en-GB/firefox/new/) (via Selenium)

The one you may not have heard of is **PhantomJS**. It is a [headless browser](https://en.wikipedia.org/wiki/Headless_browser).

> A headless browser is a web browser without a graphical user interface

**Quke** uses **PhantomJS** as its default browser. Using a headless browser the tests will run much faster and means **Quke** can also be used as part of your [CI build](https://en.wikipedia.org/wiki/Build_automation).

It is assumed you know what **Chrome** and **Firefox** are and how to install them.

### Install PhantomJS

#### Mac

We highly recommend using [Homebrew](http://brew.sh/) if you are using a **Mac** for installing packages like **PhantomJS**.

Once installed run `brew install phantomjs`

#### Linux

You'll need to

- Download either the 32bit or 64bit binary from <http://phantomjs.org/download.html>
- Extract the content and add the `bin/phantomjs` directory to your `PATH`

## Setup & Instructions

This info will be added shortly. In the meantime please refer to comments within the source code.

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
