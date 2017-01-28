require 'data_mapper'

class MinecraftUser
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :hashword, String # TODO: Figure this one out
  property :salt, String # TODO: Figure this one out as well
  property :email_address, String, :required => true
end