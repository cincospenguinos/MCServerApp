require 'data_mapper'
require 'mc_emailer'
require 'minecraft_user'
require 'yaml'

if ARGV.size != 2
  puts 'This script requires a path to the emailer config file'
  exit 1
end

db_config = YAML.load_file(ARGV[1])[:production]
DataMapper.setup(:default, "#{db_config[:db_engine]}://#{db_config[:db_username]}" +
    ":#{db_config[:db_password]}@#{db_config[:db_hostname]}" +
    "/#{db_config[:db_schema_name]}")
DataMapper.auto_upgrade!

emailer = MCEmailer.new(ARGV[0])
MinecraftUser.all(:can_startup => false).each do |user|
  while true
    puts "#{user.username} would like access to the server. What is your response? [yN]"
    resp = STDIN.gets.chomp

    if resp == 'y'
      user.allow_startup
      Thread.new { emailer.notify_accepted(user.username, user.email_address) }
      # TODO: Whitelist?
      break
    elsif resp == 'N'
      Thread.new { emailer.notify_rejected(user.username, user.email_address) }
      break
    else
      puts 'Please type y or N'
    end
  end
end