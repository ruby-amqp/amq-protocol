# encoding: binary

require "rspec"
require "pathname"

__dir = Pathname.new(File.expand_path(File.dirname(__FILE__)))

$:.unshift(__dir.parent) unless $:.include?(__dir.parent)

require "lib/amq/protocol.rb"

RSpec.configure do |config|
  config.include AMQ::Protocol
end
