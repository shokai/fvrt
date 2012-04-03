
class StreamChunk
  include Mongoid::Document
  field :checked_at, :type => Time, :default => lambda{ Time.now }
  field :stored_at, :type => Time, :default => lambda{ Time.now }
  field :retweeters, :type => Array, :default => []

  def self.find_tweet
    self.where(:_id.exists => true,
               :text.exists => true,
               :retweeted_status.exists => false)
  end

  def self.find_retweet
    self.where(:_id.exists => true,
               :text.exists => true,
               :retweeted_status.exists => true)
  end

  def self.find_info
    self.where(:text.exists => false)
  end

  def self.find_oldest_checked_tweet(interval_sec=300)
    self.find_tweet.
      where(:checked_at.lt => Time.now-interval_sec.to_i).
      asc(:checked_at)
  end

  def url
    "http://twitter.com/#{user['screen_name']}/status/#{_id}"
  end

end
