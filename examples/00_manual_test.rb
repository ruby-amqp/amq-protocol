# encoding: utf-8

require "socket"
require_relative "../lib/amqp/protocol.rb"

include AMQP::Protocol

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in(5672, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

begin
  socket.connect(sockaddr)
rescue Errno::ECONNREFUSED
  abort "Don't forget to start an AMQP broker first!"
end

# helpers
def socket.encode(klass, *args)
  STDERR.puts "#{klass}.encode(#{args.inspect[1..-2]})"
  klass.encode(*args).tap do |result|
    STDERR.puts "=> #{result.inspect}\n\n"
    self.puts(result)
  end
end

def socket.decode(klass)
  data = self.readline
  STDERR.puts "[NOT IMPLEMENTED YET] #{klass}.decode(#{data.inspect})"
  STDERR.puts "=> #{klass.decode(data).inspect}\n\n"
end

# AMQP preamble
puts "Sending AMQP preamble (#{AMQP::Protocol::PREAMBLE.inspect})\n\n"
socket.puts AMQP::Protocol::PREAMBLE

# Start/Start-Ok
socket.decode Connection::Start
socket.encode Connection::StartOk, {client: "AMQP Protocol"}, "PLAIN", "LOGINSguesPASSWORDSguest", "en_GB"

# Tune/Tune-Ok
socket.decode Connection::Tune
socket.encode Connection::TuneOk, 0, 131072, 0

socket.close
