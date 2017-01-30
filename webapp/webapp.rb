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
    @js_files << 'access_request.min.js'
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

    { :successful => false, message: 'Username and password may not be empty'}.to_json if username.empty? || password.empty?

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

  # Submit a request to access the server
  post '/access' do
    # TODO: Send a notification in a new thread
    username = params['username'].to_s
    password = params['password'].to_s
    email_address = params['email_address'].to_s

    return { :successful => false, message: 'Username and password may not be empty'}.to_json if username.empty? || password.empty? || email_address.empty?

    MinecraftUser.first_or_create(:username => username, :password => password, :email_address => email_address)

    {
        :successful => true,
        :message => ''
    }.to_json
  end
end