require 'data_mapper'
require_relative 'minecraft_user'

class StartupRequest
  include DataMapper::Resource

  Serial :id
  DateTime :request_received, :required => true

  belongs_to :minecraft_user
end