# webapp.rb
#
# Where the magic happens
require 'sinatra'
require 'json'

get '/' do
  @js_files = ['startup.min.js']
  erb :index
end

get '/map' do
  erb :map
end

get '/stats' do
  erb :stats
end

# Returns the status of the server
get '/status' do
  # TODO: this
  {
      :status => false
  }.to_json
end

post '/startup' do
  # TODO: this
  {
    :this_thing => 'needs to be done'
  }.to_json
end