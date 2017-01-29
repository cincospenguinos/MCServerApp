require 'sinatra'
require 'json'

require 'minecraft_user'

get '/' do
  @js_files = []
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
  if File.exist?('/etc/init.d/minecraft')
    {
      :status =>  !`/etc/init.d/minecraft status`.match(/not/)
    }.to_json
  else
    {
      :status => false
    }.to_json
  end
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