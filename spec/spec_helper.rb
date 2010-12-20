# encoding: binary

require "rspec"
require_relative "../lib/amq/protocol/client.rb"

RSpec.configure do |config|
  config.include AMQ::Protocol
end
