require 'sinatra/base'
require 'data_mapper'
#require_relative 'webapp'

require File.expand_path '../webapp.rb', __FILE__
#require File.join(File.dirname(__FILE__), '../webapp')

# Grab the configuration directory
db_config = nil
Dir.chdir('config') { db_config = YAML.load_file('db_config.yml') }

db_config = db_config[:development] if settings.environment == :development
db_config = db_config[:test] if settings.environment == :test
db_config = db_config[:production] if settings.environment == :production

# Install and require the proper dm adapter
require "dm-#{db_config[:db_engine]}-adapter"

# Get DataMapper setup
DataMapper::Logger.new($stdout, :debug) if settings.environment == :development
DataMapper.setup(:default, "#{db_config[:db_engine]}://#{db_config[:db_username]}" +
                     ":#{db_config[:db_password]}@#{db_config[:db_hostname]}" +
                     "/#{db_config[:db_schema_name]}")
DataMapper.auto_upgrade!

run WebApp
