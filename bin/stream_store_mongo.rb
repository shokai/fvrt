#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/../bootstrap'
require 'user_stream'
require 'ArgsParser'

parser = ArgsParser.parser
parser.comment(:verbose, 'verbose')
parser.bind(:help, :h, 'show help')

first, params = parser.parse ARGV

if parser.has_option(:help)
  puts parser.help
  exit 1
end

UserStream.configure do |config|
  config.consumer_key = @@conf['twitter']['consumer_key']
  config.consumer_secret = @@conf['twitter']['consumer_secret']
  config.oauth_token = @@conf['twitter']['access_token']
  config.oauth_token_secret = @@conf['twitter']['access_secret']
end

c = UserStream::Client.new
c.user do |s|
  begin
    next unless s.id
    s.id_ = s.id
    s.id = nil
    st = StreamTweet.new(s)
    st.save
    p st if params[:verbose]
  rescue => e
    STDERR.puts "error!! (tweet_id:\"#{s.id}\") #{e}".color(:red)
  end
end
