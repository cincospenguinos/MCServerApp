require 'data_mapper'
require_relative 'startup_request'

# TODO: Should this be shipped out to its own separate gem?

class MinecraftUser
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :hashword, String # TODO: Figure this one out
  property :salt, String # TODO: Figure this one out as well
  property :email_address, String, :required => true

  has_n :startup_requests

  # TODO: This
  def generate_hashword(password)
  end
end