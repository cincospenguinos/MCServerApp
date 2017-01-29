#!/usr/bin/ruby

require 'startup_request'

# Checks to see if minecraft needs to be shutdown or not
def is_running
  !`/etc/init.d/minecraft status`.include?('not')
end

def ten_minutes_elapsed
  StartupRequest.minutes_elapsed >= 10
end

# Checks to see if the server is empty
def server_empty
  `/etc/init.d/minecraft list`.match(/\s0\/\d+/)
end

if is_running && ten_minutes_elapsed && server_empty
  `/etc/init.d/minecraft stop`
end