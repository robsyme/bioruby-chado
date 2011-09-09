require 'rubygems'
require 'bundler'
require 'minitest/spec'
require 'minitest/autorun'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bio-chado'

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun


DataMapper.setup(:default, {
                   :adapter => "postgres",
                   :database => "chado_test",
                   :username => "rob",
                   :password => "grayishgymnosperm",
                   :host => "localhost"})
DataMapper.finalize

include Bio::Chado
