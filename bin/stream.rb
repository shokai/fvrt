#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/../bootstrap'
require 'user_stream'

UserStream.configure do |config|
  config.consumer_key = @@conf['twitter']['consumer_key']
  config.consumer_secret = @@conf['twitter']['consumer_secret']
  config.oauth_token = @@conf['twitter']['access_token']
  config.oauth_token_secret = @@conf['twitter']['access_secret']
end

c = UserStream::Client.new
c.user do |s|
  p s
end
