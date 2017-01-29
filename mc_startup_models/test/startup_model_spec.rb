require 'rspec'
require 'yaml'
require 'data_mapper'

require_relative '../lib/minecraft_user'
require_relative '../lib/startup_request'

describe 'MC Startup Models' do

  before :all do
    db_config = YAML.load_file('../../config/db_config.yml')[:test]

    `gem install dm-#{db_config[:db_engine]}-adapter`
    require "dm-#{db_config[:db_engine]}-adapter"

    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default,
                     "#{db_config[:db_engine]}://#{db_config[:db_username]}" +
                     ":#{db_config[:db_password]}@#{db_config[:db_hostname]}" +
                     "/#{db_config[:db_schema_name]}")
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  before :each do

  end

  after :each do
    StartupRequest.destroy!
    MinecraftUser.destroy!
  end

  it 'should create a password/hashword automatically for a new user' do
    user = MinecraftUser.create!(:username => 'Joe Cool', :email_address => 'joe_cool@cool.com', :password => 'secret')
    expect(MinecraftUser.first.id).to eq(user.id)
  end

  it 'should create a startup request given a correct password' do
    user = MinecraftUser.create!(:username => 'Joe Cool', :email_address => 'joe_cool@cool.com', :password => 'secret')
    expect(user.startup?('secret')).to be_truthy
    expect(StartupRequest.first).to be_truthy
  end

  it 'should not create a startup request given an incorrect password' do
    user = MinecraftUser.create!(:username => 'Joe Cool', :email_address => 'joe_cool@cool.com', :password => 'secret')
    expect(user.startup?('not_secret')).to be_falsey
    expect(StartupRequest.first).to be_falsey
  end
end