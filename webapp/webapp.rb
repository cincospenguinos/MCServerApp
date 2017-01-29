require 'sinatra'
require 'json'

require 'minecraft_user'

helpers do
  def server_on?
    return !`/etc/init.d/minecraft status`.match(/not/) if File.exist?('/etc/init.d/minecraft')
    false
  end
end

before %r((^\/$|map|stats)) do
  @js_files = []
  @css_files = []
  @server_on = server_on?
end

get '/' do
  @server_on = server_on?
  @css_files = ['index_stylesheet.min.css']
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
  {
    :status =>  server_on?
  }.to_json
end

# Starts up the server given the correct username/password
post '/startup' do
  username = params['username']
  password = params['password']

  user = MinecraftUser.first(:username => username)

  if user && user.startup?(password)
    `/etc/init.d/minecraft start &`
    {
      :successful => true,
      :message => ''
    }.to_json
  end

  {
      :successful => false,
      :message => 'Username/password incorrect'
  }.to_json
end