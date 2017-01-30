require 'sinatra'
require 'json'
require 'yaml'

require 'minecraft_user'

class WebApp < Sinatra::Base

  helpers do
    def server_on?
      return !`#{startup_config[:full_file_path]} #{startup_config[:status]}`.match(/not/) if File.exist?('/etc/init.d/minecraft')
      false
    end
  end

  before %r((^\/$|map|stats)) do
    @js_files = []
    @css_files = []
    @server_on = server_on?
  end

  get '/' do
    @css_files << 'index_stylesheet.min.css'
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
      startup_config = YAML.load_file('config/startup_script_config.yml')
      `#{startup_config[:full_file_path]} #{startup_config[:start]} &`
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
end