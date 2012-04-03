#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/../bootstrap'
require 'Twitter'
require 'ArgsParser'

parser = ArgsParser.parser
parser.comment(:loop, 'run loop')
parser.bind(:interval, :i, 'check interval (sec)', 300)
parser.bind(:help, :h, 'show help')

first, params = parser.parse ARGV

if parser.has_option(:help)
  puts parser.help
  puts "e.g.  ruby -Ku #{$0} --loop -i 300"
  exit 1
end

Twitter.configure do |config|
  config.consumer_key = @@conf['twitter']['consumer_key']
  config.consumer_secret = @@conf['twitter']['consumer_secret']
  config.oauth_token = @@conf['twitter']['access_token']
  config.oauth_token_secret = @@conf['twitter']['access_secret']
end

loop do
  scs = StreamChunk.find_oldest_checked_tweet(params[:interval].to_i)
  puts "#{scs.count} tweets in queue"
  sc = scs.first
  if sc
    puts "check #{sc.url}"
    begin
      rets = Twitter.retweeters_of(sc.id)
      puts "retweet : #{rets.size}".color(:green)
      sc.retweet_count = rets.size
      sc.retweeters = rets.map{|u|
        {
          :name => u.screen_name,
          :icon => u.profile_image_url
        }
      }
      sc.checked_at = Time.now
      sc.save
    rescue Twitter::Error::NotFound => e
      STDERR.puts e.to_s.color(:red)
      sc.delete
    rescue => e
      STDERR.puts e.to_s.color(:red)
    end
  end
  break unless params[:loop]
  sleep 5
end
