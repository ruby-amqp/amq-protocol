# encoding: binary

require "socket"
require_relative "../lib/amqp/protocol.rb"

include AMQP::Protocol

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in((ARGV.first || 5672).to_i, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

begin
  socket.connect(sockaddr)
rescue Errno::ECONNREFUSED
  abort "Don't forget to start an AMQP broker first!"
end

# helpers
Frame.encode(:method, 0, Connection::TuneOk.encode(0, 131072, 0))

def socket.encode(klass, *args)
  STDERR.puts "#{klass}.encode(#{args.inspect[1..-2]})"
  klass.encode(*args).tap do |result|
    STDERR.puts "=> #{result.inspect}"
    STDERR.puts "Frame.encode(:method, 0, #{result.inspect})"
    STDERR.puts "=> #{Frame.encode(:method, 0, result).inspect}\n\n"
    self.puts(result)
  end
end

def socket.decode
  frame = Frame.new(self)
  STDERR.puts "Frame.new(#{self.inspect})"
  STDERR.puts "=> #{frame.inspect}\n\n"
end

# AMQP preamble
puts "Sending AMQP preamble (#{AMQP::Protocol::PREAMBLE.inspect})\n\n"
socket.puts AMQP::Protocol::PREAMBLE

# Start/Start-Ok
socket.decode
socket.encode Connection::StartOk, {client: "AMQP Protocol"}, "PLAIN", "LOGINSguesPASSWORDSguest", "en_GB"

# Tune/Tune-Ok
socket.encode Connection::TuneOk, 0, 131072, 0
# socket.decode

# Close
socket.encode Connection::Close
socket.decode

socket.close
