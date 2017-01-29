require 'bcrypt'
require 'data_mapper'

require_relative 'startup_request'

class MinecraftUser
  include DataMapper::Resource, BCrypt

  property :id, Serial
  property :username, String, :required => true, :unique => true
  property :password, String, :required => true # Actually a hashword, but whatever
  property :email_address, String, :required => true, :format => :email_address

  has n, :startup_requests

  validates_with_method :has_hashword

  before :save do
    password = Password.create(password)
  end

  def startup?(provided_pass)
    if provided_pass == password
      request = StartupRequest.create!(:minecraft_user => self)
      request
    else
      false
    end
  end
end