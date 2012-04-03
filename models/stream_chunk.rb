
class StreamChunk
  include Mongoid::Document
  field :checked_at, :type => Time, :default => nil

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

  def self.find_not_checked_tweet
    self.find_tweet.where(:checked_at.exists => false)
  end

  def self.find_oldest_checked_tweet
    self.find_tweet.
      where(:_id.exists => true,
            :checked_at.exists => true).desc(:checked_at)
  end

  def url
    "http://twitter.com/#{user['screen_name']}/status/#{_id}"
  end

end
