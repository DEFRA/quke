After('~@nonweb') do |scenario|
  if scenario.failed?
    # Tell Cucumber to quit after first failing scenario when phantomjs is
    # used. The expectation is that you are using phantomjs as part of your
    # CI and therefore a fast response is better than a detailed response
    if $driver == :phantomjs
      Cucumber.wants_to_quit = true
      return
    end

    # Experience has shown that should a major element of your service go
    # down all your tests will start failing which means you can be swamped
    # with output from `save_and_open_page`. This keeps a global count of the
    # number of fails, and if it hits 5 it will cause cucumber to close.
    $fail_count ||= 0
    $fail_count = $fail_count + 1
    if $fail_count >= 5
      Cucumber.wants_to_quit = true
      return
    end

    # If we're not using poltergiest and the scenario has failed, we want
    # to save a copy of the page and open it automatically using Launchy.
    # We wrap this in a begin/rescue in case of any issues in which case
    # it defaults to outputting the source to STDOUT.
    begin
      # rubocop:disable Lint/Debugger
      save_and_open_page
      # rubocop:enable Lint/Debugger
    rescue StandardError
      # handle e
      puts "FAILED: #{scenario.name}"
      puts "FAILED: URL of the page with the test failure #{page.current_path}"
      puts ''
      puts page.html
    end
  end
end
