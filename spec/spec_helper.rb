# encoding: binary

require "rspec"
require_relative "../lib/amq/protocol.rb"

RSpec.configure do |config|
  config.include AMQ::Protocol
end
