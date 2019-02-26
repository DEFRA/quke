# frozen_string_literal: true

require "quke/configuration"

Before("not @nonweb") do
  # We have to make a special case for phantomjs when it comes to implementing
  # the ability to override the user agent. Unlike the selinium backed drivers
  # specifying the user agent is not part of the arguments we pass in when
  # initialising the driver. Instead its something we call on the driver once
  # its been instantiated
  # https://github.com/teampoltergeist/poltergeist#manipulating-request-headers
  # That might not have been so bad, the folks behind poltergeist have also
  # made it so that custom changes to the header only last for as long as the
  # test is running. Once a test finishes, the changes are lost.
  # Hence the only way we can ensure its set across all tests is by making use
  # of the Before hook, and adding the User-Agent header each time.
  if Quke::Quke.config.driver == "phantomjs"
    unless Quke::Quke.config.user_agent.empty?
      page.driver.add_header(
        "User-Agent",
        Quke::Quke.config.user_agent,
        permanent: true
      )
    end
  end
end
