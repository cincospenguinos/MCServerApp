require 'data_mapper'
require_relative 'webapp'

# Grab the configuration directory
`cp -R ../config .` unless File.directory?('config')
db_config = nil
Dir.chdir('config') { db_config = YAML.load_file('db_config.yml') }

db_config = db_config[:development] if settings.environment == :development
db_config = db_config[:test] if settings.environment == :test
db_config = db_config[:production] if settings.environment == :production

# Get DataMapper setup
DataMapper::Logger.new($stdout, :debug) if settings.environment == :development
DataMapper.setup(:default, "#{db_config[:db_engine]}://#{db_config[:db_username]}" +
                     ":#{db_config[:db_password]}@#{db_config[:db_hostname]}" +
                     "/#{db_config[:db_schema_name]}")
DataMapper.auto_upgrade!

run Sinatra::Application