require 'data_mapper'
require_relative 'webapp'

# TODO: Setup the database according to the configuration files and RACK_ENV
unless File.exist?('config/db_config.yml')
  puts 'Run `rake setup` before attempting to deploy this application'
  exit 1
end

# TODO: get the DB Configuration stuff figured out

run Sinatra::Application