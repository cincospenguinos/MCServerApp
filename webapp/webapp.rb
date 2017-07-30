require 'sinatra'
require 'json'
require 'yaml'

require 'minecraft_user'
require 'mc_emailer'

class WebApp < Sinatra::Base

  helpers do
    def startup_config
      YAML.load_file('config/startup_script_config.yml')
    end
    
    def server_on?
      cfg = startup_config
      return !`#{cfg[:full_file_path]} #{cfg[:status]}`.match(/not/) if File.exist?('/etc/init.d/minecraft')
      false
    end
  end

  before %r((^\/$|map|stats|rules)) do
    @js_files = []
    @css_files = []
    @server_on = server_on?
  end

  get '/' do
    @css_files << 'index_stylesheet.min.css'
    @js_files << 'access_request.min.js'
    @screenshots = Dir['public/images/*.*']
    puts "~ #{@screenshots}"
    erb :index
  end

  get '/map' do
    redirect 'http://andreminecraft.duckdns.org:8123'
  end

  get '/stats' do
    erb :stats
  end

  get '/rules' do
    erb :rules
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
    startup = user.startup?(password)
    if user && startup
      puts "~~~~#{startup.date_received}"
      Thread.new {
        startup_config = YAML.load_file('config/startup_script_config.yml')
        `#{startup_config[:full_file_path]} #{startup_config[:start]}`
      }
      return { :successful => true, :message => '' }.to_json
    end

    {
      :successful => false,
      :message => 'Username/password incorrect'
    }.to_json
  end

  # Submit a request to access the server
  post '/access' do
    username = params['username'].to_s
    password = params['password'].to_s
    email_address = params['email_address'].to_s

    error = { :successful => false, message: 'Username and password may not be empty'}.to_json
    return error if username.empty? || password.empty? || email_address.empty?

    Thread.new {
      user = MinecraftUser.first_or_create(:username => username, :password => password, :email_address => email_address)
      emailer = MCEmailer.new('config/email_config.yml')
      emailer.notify_request(user.username, user.email_address)
    }

    {
        :successful => true,
        :message => ''
    }.to_json
  end
end

