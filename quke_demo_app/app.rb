require 'sinatra'

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

# To enable reloading of the app whilst working on it follow you can use Rerun
# https://github.com/alexch/rerun
# http://www.sinatrarb.com/faq.html#reloading
# `gem install rerun`
# `rerun quke_demo_app/app.rb`
