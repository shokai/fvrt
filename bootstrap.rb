require 'rubygems'
require 'bundler/setup'
require 'yaml'

begin
  @@conf = YAML::load open(File.dirname(__FILE__) + '/config.yaml')
rescue
  STDERR.puts 'config.yaml load error'
  exit 1
end
