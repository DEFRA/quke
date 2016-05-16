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
bundle install
```

[Bundler](http://bundler.io/) will download everything needed for the project. Once complete you're good to go!

## Execution

Quke comes with some inbuilt commands which provide a shorthand for the most common use cases.

- `bundle exec rake`
  - This will run Quke using its default browser choice (PhantomJS)
- ` bundle exec rake chrome`
  - This will run Quke using Chrome
- ` bundle exec rake firefox`
  - This will run Quke using Firefox

If you want more control and access to all the options available to cucumber (see the full list with `bundle exec cucumber --help`) run Quke using

```bash
bundle exec cucumber
```

### Options

Quke recognises 2 options which are read from environment variables. The easiest way to do this is on the command line.

- **DRIVER** - Tells Quke which browser to use for testing
  - `DRIVER=chrome bundle exec cucumber`
- **PAUSE** - Add a pause (in seconds) between steps so you can visually track how the browser is responding
  - `PAUSE=1 bundle exec rake chrome`

You can combine these options along with arguments to be passed to Cucumber

```bash
DRIVER=chrome PAUSE=1 bundle exec cucumber -t @smoke
```

This is telling Quke to use Chrome as its browser for testing, to pause for 1 second between steps, and to run only those features and scenarios tagged with `@smoke`.

### Why `bundle exec`?

Using `bundle exec` at the start of each command is to ensure we are using the version of a *thing* that was installed in the context of Quke, which in our case is Cucumber. While a command may work without it, doing so is unreliable and should be avoided.

### Confirming it works

Included in Quke are some feature tests which can be used for reference, but also to confirm you have it setup and working correctly. Having completed [installation](#installation) running `bundle exec cucumber` should return the following

```bash
Using the default profile...
0 scenarios
0 steps
0m0.000s
```

You can then run the included tests with `bundle exec cucumber -p quke` and should see successful output from each of the tests plus an updated summary (you will need access to [Wikipedia](https://en.wikipedia.org/wiki/Main_Page) else the tests will fail).

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
