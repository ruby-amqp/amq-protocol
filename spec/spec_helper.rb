# encoding: binary

require "rspec"
require_relative "../lib/amqp/protocol.rb"

RSpec.configure do |config|
  config.include AMQP::Protocol
end
