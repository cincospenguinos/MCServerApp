# webapp.rb
#
# Where the magic happens
require 'sinatra'

puts "\n#{Process.pid} is my PID"
get '/' do
  erb :index
end