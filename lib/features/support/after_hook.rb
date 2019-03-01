# frozen_string_literal: true

require "quke/configuration"

# Because of the way cucumber works everthing is made global. This also means
# any variables we set also need to be made global so they can be accessed
# across the scenarios.
# rubocop:disable Style/GlobalVars
After("not @nonweb") do |scenario|
  $fail_count ||= 0

  $session_id = page.driver.browser.session_id if Quke::Quke.config.browserstack.using_browserstack?

  if scenario.failed?
    $fail_count = $fail_count + 1

    # Experience has shown that should a major element of your service go
    # down all your tests will start failing which means you can be swamped
    # with output from `save_and_open_page`. Using a global count of the
    # number of fails, if it hits 5 it will cause cucumber to close.
    if $fail_count >= 5 && !%w["chrome firefox"].include?(Quke::Quke.config.driver)
      Cucumber.wants_to_quit = true
    else
      # Depending on our config, driver and whether we are running headless we
      # may want to save a copy of the page and open it automatically using
      # Launchy. We wrap this in a begin/rescue in case of any issues in which
      # case it defaults to outputting the source to STDOUT.
      begin
        # rubocop:disable Lint/Debugger
        save_and_open_page if Quke::Quke.config.display_failures?
        # rubocop:enable Lint/Debugger
      rescue StandardError
        # handle e
        puts "FAILED: #{scenario.name}"
        puts "FAILED: URL of the page with the failure #{page.current_path}"
        puts ""
        puts page.html
      end
    end
  end
end
# rubocop:enable Style/GlobalVars
