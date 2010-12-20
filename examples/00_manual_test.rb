# encoding: binary

require "socket"
require_relative "../lib/amq/protocol/client.rb"

include AMQ::Protocol

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in((ARGV.first || 5672).to_i, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

# helpers
def socket.encode(klass, *args)
  STDERR.puts "#{klass}.encode(#{args.inspect[1..-2]})"
  result = klass.encode(*args)
  if result.is_a?(Frame)
    self.write(result.encode)
  else
    data = result.inject("") { |buffer, frame| buffer += frame.encode }
    self.write(data)
  end
end

def socket.decode
  frame = Frame.decode(self)
  STDERR.puts "Frame.decode(#{self.inspect})"
  STDERR.puts "=> #{frame.inspect}"
  STDERR.puts "frame.decode_payload"
  STDERR.puts "=> #{res = frame.decode_payload}\n\n"
  return res
end

begin
  socket.connect(sockaddr)
rescue Errno::ECONNREFUSED
  abort "Don't forget to start an AMQP broker first!"
end

begin
  # AMQP preamble
  puts "Sending AMQP preamble (#{AMQ::Protocol::PREAMBLE.inspect})\n\n"
  socket.write AMQ::Protocol::PREAMBLE

  # Connection.Start/Connection.Start-Ok
  connection_start_response = socket.decode
  socket.encode Connection::StartOk, {client: "AMQ Protocol"}, "PLAIN", "guest\0guest\0", "en_GB"

  # Connection.Tune/Connection.Tune-Ok
  connection_tune_response = socket.decode
  channel_max = connection_tune_response.channel_max
  frame_max   = connection_tune_response.frame_max
  heartbeat   = connection_tune_response.heartbeat
  socket.encode Connection::TuneOk, channel_max, frame_max, heartbeat
  puts "Max agreed frame size: #{frame_max}"

  # Connection.Open/Connection.Open-Ok
  socket.encode Connection::Open, "/", "0", false
  # TODO: capabilities & insist MUST be zero,
  # we need to adjust the JSON file for 0.9.1,
  # basically we want to hide them in the clients
  # as they can't be set to any other value.
  connection_open_ok_response = socket.decode

  # Channel.Start/Channel.Start-Ok
  socket.encode Channel::Start
  channel_start_ok_response = socket.decode

  # Exchange.Declare/Exchange.Declare-Ok
  socket.encode Exchange::Declare
  exchange_declare_ok_response = socket.decode

  # Channel.Close/Channel.Close-Ok
  socket.encode Channel::Close
  channel_close_ok_response = socket.decode

  # Connection.Close/Connection.Close-Ok
  socket.encode Connection::Close, 200, "", 0, 0
  # are these good args?
  # reply_code, reply_text, class_id, method_id = 200, "", 0, 0
  close_ok_response = socket.decode
ensure
  socket.close
end

__END__
[CLIENT] conn#4 ch#0 -> {#method<connection.open>(virtual-host=/,capabilities=,insist=false),null,""}
[SERVER] conn#4 ch#0 <- {#method<connection.open-ok>(known-hosts=),null,""}
