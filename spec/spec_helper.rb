# encoding: binary

require "rspec"
require "pathname"

__dir = Pathname.new(File.expand_path(File.dirname(__FILE__)))

$:.unshift(__dir.parent) unless $:.include?(__dir.parent)

require "lib/amq/protocol.rb"

module RubyVersionsSUpport
  def one_point_eight?
    RUBY_VERSION =~ /^1.8/
  end
end # RubyVersionsSUpport


RSpec.configure do |config|
  config.include AMQ::Protocol

  config.include(RubyVersionsSUpport)
  config.extend(RubyVersionsSUpport)
end
