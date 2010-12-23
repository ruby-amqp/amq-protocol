# encoding: binary

require "socket"
require_relative "../lib/amq/protocol/client.rb"

include AMQ::Protocol

socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in((ARGV.first || 5672).to_i, "127.0.0.1") # NOTE: this doesn't work with "localhost", I don't know why.

# helpers
def socket.encode(channel, klass, *args)
  STDERR.puts "#{klass}.encode(#{args.inspect[1..-2]})"
  result = klass.encode(*args)
  if result.is_a?(Frame)
    result.channel = channel
    self.write(result.encode)
  else
    data = result.inject("") do |buffer, frame|
      frame.channel = channel
      self.write(frame.encode) ###
      buffer += frame.encode
    end
    # self.write(data)
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
  socket.encode 0, Connection::StartOk, {client: "AMQ Protocol"}, "PLAIN", "guest\0guest\0", "en_GB"

  # Connection.Tune/Connection.Tune-Ok
  connection_tune_response = socket.decode
  channel_max = connection_tune_response.channel_max
  frame_max   = connection_tune_response.frame_max
  heartbeat   = connection_tune_response.heartbeat
  socket.encode 0, Connection::TuneOk, channel_max, frame_max, heartbeat
  puts "Max agreed frame size: #{frame_max}"

  # Connection.Open/Connection.Open-Ok
  socket.encode 0, Connection::Open, "/"
  connection_open_ok_response = socket.decode

  # Channel.Open/Channel.Open-Ok
  socket.encode 1, Channel::Open, ""
  channel_open_ok_response = socket.decode

  # Exchange.Declare/Exchange.Declare-Ok
  socket.encode 1, Exchange::Declare, "tasks", "fanout", false, false, false, false, {}
  exchange_declare_ok_response = socket.decode

  # Basic.Publish
  socket.encode 1, Basic::Publish, "this is a payload", {a: 1}, "tasks", "", false, false, frame_max

  # Channel.Close/Channel.Close-Ok
  socket.encode 1, Channel::Close, 200, "bye", 0, 0
  channel_close_ok_response = socket.decode

  # Connection.Close/Connection.Close-Ok
  socket.encode 0, Connection::Close, 200, "", 0, 0
  # are these good args?
  # reply_code, reply_text, class_id, method_id = 200, "", 0, 0
  close_ok_response = socket.decode
ensure
  socket.close
end
