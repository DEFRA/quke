# frozen_string_literal: true

module Quke # :nodoc:

  # Used to update the status of a session in Browserstack to mark it as passed
  # or failed. It does this by making a PUT request to Browserstack's REST API
  # requesting the status of a specified session is set to 'passed' or 'failed'
  # (only those values are accepted).
  #
  # https://www.browserstack.com/automate/rest-api
  #
  # A session ID is only available when we configure Quke to work with
  # Browserstack, and can only be obtained when in the context of running a
  # scenario. It's unique to the overall session (it doesn't change for each
  # scenario or feature), but we have to set it as a global variable in
  # after_hook.rb in order to access it in the after_exit block in env.rb
  class BrowserstackStatusReporter

    # Initialize's the instance based in the +Quke::BrowserstackConfiguration+
    # instance passed in.
    #
    # The values its interested in are username and auth_key as it will use
    # these to authenticate with Browserstacks REST API.
    def initialize(config)
      @username = config.username
      @auth_key = config.auth_key
    end

    # Connects to the Browserstack REST API and makes a PUT request to update
    # the session with the matching +session_id+ to 'passed'.
    #
    # It returns a string which can be used as a message for output confirming
    # the action.
    def passed(session_id)
      check_before_update(session_id, status: "passed")
      "Browserstack session #{session_id} status set to \e[32mpassed\e[0m 😀"
    end

    # Connects to the Browserstack REST API and makes a PUT request to update
    # the session with the matching +session_id+ to 'failed'.
    #
    # It returns a string which can be used as a message for output confirming
    # the action.
    def failed(session_id)
      check_before_update(session_id, status: "failed")
      "Browserstack session #{session_id} status set to \e[31mfailed\e[0m 😢"
    end

    private

    def check_before_update(session_id, body)
      raise(ArgumentError, "Need a session ID to update browserstack status") if session_id.nil?

      uri = URI("https://www.browserstack.com/automate/sessions/#{session_id}.json")
      set_status(uri, body)
    end

    def set_status(uri, body)
      request = Net::HTTP::Put.new(uri)
      request.basic_auth @username, @auth_key
      request.content_type = "application/json"
      request.body = body.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      return if response.is_a? Net::HTTPSuccess

      raise(StandardError, "Failed to update browserstack status: #{uri}")
    end

  end

end
