require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'mongoid'
require 'rainbow'

begin
  @@conf = YAML::load open(File.dirname(__FILE__) + '/config.yaml')
rescue
  STDERR.puts 'config.yaml load error'
  exit 1
end

Mongoid.configure do |conf|
  host = @@conf['mongo']['host']
  port = @@conf['mongo']['port']
  conf.master = Mongo::Connection.new.db(@@conf['mongo']['database'])
end

[:helpers, :models].each do |dir|
  Dir.glob(File.dirname(__FILE__)+"/#{dir}/*.rb").each do |rb|
    require rb
  end
end
