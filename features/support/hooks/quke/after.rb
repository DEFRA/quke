After('~@nonweb') do |scenario|
  if scenario.failed?
    # Tell Cucumber to quit after first failing scenario when poltergeist is
    # used. The expectation is that you are using poltergeist as part of your
    # CI and therefore a fast response is better than a detailed response
    if $driver == :poltergeist
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
