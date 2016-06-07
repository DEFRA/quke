require 'sinatra'

# This require was only added to stop this warning from appearing in the output
# WARN: tilt autoloading 'tilt/erubis' in a non thread-safe way;
# explicit require 'tilt/erubis' suggested
require 'tilt/erubis'

# We don't want the browser caching the assets so we specify this to prevent it
set :static_cache_control, [:public, max_age: 0]

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
  @query = params['search_input']
  puts @query

  # rubocop:disable Metrics/LineLength
  @results = {
    Capybara: 'The capybara (Hydrochoerus hydrochaeris) is a large rodent of the genus Hydrochoerus of which the only other extant member is the lesser capybara (Hydrochoerus isthmius). The capybara is the largest rodent in the world. Close relatives are guinea pigs and rock cavies, and it is more distantly related to the agouti, chinchillas, and the coypu. Native to South America, the capybara inhabits savannas and dense forests and lives near bodies of water. It is a highly social species and can be found in groups as large as 100 individuals, but usually lives in groups of 10–20 individuals. The capybara is not a threatened species and is hunted for its meat and hide and also for a grease from its thick fatty skin which is used in the pharmaceutical trade.',
    Capybara_software: 'Capybara is a web-based test automation software that simulates scenarios for user stories and automates web application testing for behavior-driven software development. It is a part of the Cucumber testing framework written in the Ruby programming language that simulates various aspects of a web browser from the perspective of a real user.'
  } if @query.casecmp('capybara') == 0
  # rubocop:enable Metrics/LineLength
  puts @results

  erb :search
end

# To enable reloading of the app whilst working on it you can use Rerun
# https://github.com/alexch/rerun
# http://www.sinatrarb.com/faq.html#reloading
# `gem install rerun`
# `rerun quke_demo_app/app.rb`
