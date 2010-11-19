# encoding: utf-8

require "socket"
require_relative "../lib/amqp/protocol.rb"

server = TCPServer.new(5672)

begin
  socket = server.accept_nonblock
rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
  IO.select([server])
  retry
end
# AMQP::Protocol::Connection::Start.encode
