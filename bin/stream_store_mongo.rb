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
  begin
    id = 'null'
    if s.id
      id = s.id
      s.id_ = s.id
      s.id = nil
    end
    st = StreamTweet.new(s)
    st.save
    p st
  rescue => e
    STDERR.puts "error!! (tweet_id:\"#{id}\") #{e}".color(:red)
  end
end
