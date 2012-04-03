#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/../bootstrap'
require 'Twitter'
require 'ArgsParser'

parser = ArgsParser.parser
parser.comment(:verbose, 'verbose')
parser.comment(:loop, 'run loop')
parser.bind(:interval, :i, 'loop interval', 5)
parser.bind(:help, :h, 'show help')

first, params = parser.parse ARGV

if parser.has_option(:help)
  puts parser.help
  puts "e.g.  ruby -Ku #{$0} --verbose --loop -i 5"
  exit 1
end

Twitter.configure do |config|
  config.consumer_key = @@conf['twitter']['consumer_key']
  config.consumer_secret = @@conf['twitter']['consumer_secret']
  config.oauth_token = @@conf['twitter']['access_token']
  config.oauth_token_secret = @@conf['twitter']['access_secret']
end

loop do
  sleep params[:interval].to_f
  sc = StreamChunk.find_oldest_checked_tweet.limit(1).first
  next unless sc
  puts "check #{sc.url}" if params[:verbose]
  begin
    rets = Twitter.retweeters_of(sc.id)
    puts "retweet : #{rets.size}" if params[:verbose]
    sc.retweet_count = rets.size
    sc.retweeters = rets.map{|u|
      {
        :name => u.screen_name,
        :icon => u.profile_image_url
      }
    }
    sc.checked_at = Time.now
    sc.save
  rescue => e
    STDERR.puts e
  end
  break unless params[:loop]
end
