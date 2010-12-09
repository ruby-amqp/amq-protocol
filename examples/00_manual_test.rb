# encoding: utf-8

require "socket"
require_relative "../lib/amqp/protocol.rb"

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0 )
sockaddr = Socket.pack_sockaddr_in(5672, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

begin
  socket.connect(sockaddr)
rescue Errno::ECONNREFUSED
  abort "Don't forget to start an AMQP broker first!"
end

# socket.puts "Hello from script 2."
# puts "The server said, '#{socket.readline.chomp}'"

# AMQP::Protocol::Connection::Start.decode

# {#method<connection.start-ok>(client-properties={product=AMQP, information=http://github.com/tmm1/amqp, platform=Ruby/EventMachine, version=0.6.7},mechanism=AMQPLAIN,response=LOGINSguesPASSWORDSguest,locale=en_US),null,""}
# ["client_properties = nil", "mechanism = "PLAIN"", "response = nil", "locale = "en_US""]
socket.puts AMQP::Protocol::Connection::StartOk.encode({client: "AMQP Protocol"}, "PLAIN", "LOGINSguesPASSWORDSguest", "en_GB")

socket.close
