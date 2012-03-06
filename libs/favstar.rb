require 'rubygems'
require 'simple-rss'
require 'open-uri'

class Favstar
  class Error < StandardError
  end

  class Fav
    attr_accessor :count, :id, :text, :name
    def initialize(params)
      if params.class == Hash
        params.each do |k,v|
          instance_eval("@#{k} = v")
        end
      end
    end
  end

  # get recent favs
  # @return Tweet instance
  def self.recent_favs(user_name)
    rss = SimpleRSS.parse open("http://favstar.fm/users/#{user_name}/rss").read
    rss.items.map{|i|
      Fav.new(:count => i.title.scan(/^\d+/)[0].to_i,
              :text => i.title.scan(/^\d+\s*stars?:\s*(.+)/)[0][0],
              :id => i.link.scan(/\d+$/)[0].to_i,
              :name => user_name)
    }
  end
end


if __FILE__ == $0
  user = ARGV.empty? ? 'shokai' : ARGV.shift

  Favstar.recent_favs(user).each do |fav|
    puts "#{'★'*fav.count} #{fav.text} [id:#{fav.id}]"
  end
end
