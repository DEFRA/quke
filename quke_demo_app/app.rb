require 'sinatra'

# This require was only added to stop this warning from appearing in the output
# WARN: tilt autoloading 'tilt/erb' in a non thread-safe way;
# explicit require 'tilt/erb' suggested
require 'tilt/erb'

configure do
  # We enable sessions to allow us to place things in the session like flash
  # messages
  enable :sessions

  # We don't want the browser caching the assets so we specify this
  set :static_cache_control, [:public, max_age: 0]

  # It's not critical for this app, but best practise is to secure your session
  # with a secret key, and this also stops Sinatra complaining!
  set :session_secret, SECRET ||= 'super secret'.freeze
end

get '/' do
  @title = 'Welcome to Quke'
  erb :index
end

get '/about' do
  @title = 'About'
  erb :about
end

get '/contact' do
  @title = 'Contact'
  erb :contact
end

get '/search' do
  @title = 'Search'
  erb :search
end

post '/search' do
  @title = 'Search'

  @query = params['search_input']

  # rubocop:disable Metrics/LineLength
  @results = {
    Capybara: 'The capybara (Hydrochoerus hydrochaeris) is a large rodent of the genus Hydrochoerus of which the only other extant member is the lesser capybara (Hydrochoerus isthmius). The capybara is the largest rodent in the world. Close relatives are guinea pigs and rock cavies, and it is more distantly related to the agouti, chinchillas, and the coypu. Native to South America, the capybara inhabits savannas and dense forests and lives near bodies of water. It is a highly social species and can be found in groups as large as 100 individuals, but usually lives in groups of 10–20 individuals. The capybara is not a threatened species and is hunted for its meat and hide and also for a grease from its thick fatty skin which is used in the pharmaceutical trade.',
    Capybara_software: 'Capybara is a web-based test automation software that simulates scenarios for user stories and automates web application testing for behavior-driven software development. It is a part of the Cucumber testing framework written in the Ruby programming language that simulates various aspects of a web browser from the perspective of a real user.'
  } if @query.casecmp('capybara') == 0
  # rubocop:enable Metrics/LineLength

  erb :search
end

get '/radiobutton' do
  @title = 'Radio button'
  erb :radio_button
end

post '/radiobutton' do
  @title = 'Radio button'
  @selection = params['enrollment']['organisation_attributes']['type']
  @result = @selection.match(/OrganisationType::([^"]*)/)[1]

  erb :radio_button
end

get '/cssselector' do
  @title = 'CSS selector'
  erb :css_selector
end
