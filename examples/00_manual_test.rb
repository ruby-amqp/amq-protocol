# encoding: binary

require "socket"
require_relative "../lib/amq/protocol.rb"

include AMQ::Protocol

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in((ARGV.first || 5672).to_i, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

begin
  socket.connect(sockaddr)
rescue Errno::ECONNREFUSED
  abort "Don't forget to start an AMQP broker first!"
end

# helpers
MethodFrame.encode(:method, 0, Connection::TuneOk.encode(0, 131072, 0))

def socket.encode(klass, *args)
  STDERR.puts "#{klass}.encode(#{args.inspect[1..-2]})"
  klass.encode(*args).tap do |result|
    STDERR.puts "=> #{result.inspect}"
    STDERR.puts "MethodFrame.encode(:method, 0, #{result.inspect})"
    STDERR.puts "=> #{MethodFrame.encode(:method, 0, result).inspect}\n\n"
    self.write(MethodFrame.encode(:method, 0, result))
  end
end

def socket.decode
  frame = MethodFrame.decode(self)
  STDERR.puts "MethodFrame.decode(#{self.inspect})"
  STDERR.puts "=> #{frame.inspect}\n\n"
end

# AMQP preamble
puts "Sending AMQP preamble (#{AMQ::Protocol::PREAMBLE.inspect})\n\n"
socket.write AMQ::Protocol::PREAMBLE

# Start/Start-Ok
socket.decode
socket.encode Connection::StartOk, {client: "AMQ Protocol"}, "PLAIN", "guest\0guest\0", "en_GB"

# Tune/Tune-Ok
socket.decode
socket.encode Connection::TuneOk, 0, 131072, 0

# Close
# socket.encode Connection::Close
# socket.decode

socket.close

__END__
[CLIENT] conn#4 ch#0 -> {#method<connection.start-ok>(client-properties={product=AMQP, information=http://github.com/tmm1/amqp, platform=Ruby/EventMachine, version=0.6.7},mechanism=AMQPLAIN,response=LOGINSguesPASSWORDSguest,locale=en_US),null,""}
[SERVER] conn#4 ch#0 <- {#method<connection.start>(version-major=8,version-minor=0,server properties={product=RabbitMQ, information=Licensed under the MPL.  See http://www.rabbitmq.com/, platform=Erlang/OTP, copyright=Copyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd., version=2.1.0},mechanisms=PLAIN AMQPLAIN,locales=en_US),null,""}
[SERVER] conn#4 ch#0 <- {#method<connection.tune>(channel-max=0,frame-max=131072,heartbeat=0),null,""}
[CLIENT] conn#4 ch#0 -> {#method<connection.tune-ok>(channel-max=0,frame-max=131072,heartbeat=0),null,""}
[CLIENT] conn#4 ch#0 -> {#method<connection.open>(virtual-host=/,capabilities=,insist=false),null,""}
[SERVER] conn#4 ch#0 <- {#method<connection.open-ok>(known-hosts=),null,""}
