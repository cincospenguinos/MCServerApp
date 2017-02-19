require 'bcrypt'
require 'data_mapper'

require_relative 'startup_request'

# TODO: This stores plaintext user passwords! Fix it!

class MinecraftUser
  include DataMapper::Resource, BCrypt

  property :id, Serial
  property :username, String, :required => true, :unique => true
  property :password, String, :required => true # Actually a hashword, but whatever
  property :email_address, String, :required => true, :format => :email_address
  property :can_startup, Boolean, :default => false

  has n, :startup_requests

  before :save do
    password = Password.create(password)
  end

  # Allow user to startup the server
  def allow_startup
    update(:can_startup => true)
  end

  # Verifies whether or not the provided password is correct and creates
  #  a StartupRequest if it is
  def startup?(provided_pass)
    if can_startup && provided_pass == password
      request = StartupRequest.create!(:minecraft_user => self, :date_received => DateTime.now)
      request
    else
      false
    end
  end
end
