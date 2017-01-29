require 'data_mapper'
require_relative 'minecraft_user'

class StartupRequest
  include DataMapper::Resource

  property :id, Serial
  property :date_received, DateTime, :default => DateTime.now

  belongs_to :minecraft_user

  # Returns number of minutes elapsed since startup request
  def self.minutes_elapsed
    now = DateTime.now
    past = StartupRequest.last.date_received
    (now - past).to_i.abs / 60
  end
end