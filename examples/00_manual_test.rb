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
  STDERR.puts "=> #{result}"
  if result.is_a?(Frame)
    self.write(result.encode)
  else
    data = result.inject("") do |buffer, frame|
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
  socket.encode Connection::StartOk, {client: "AMQ Protocol"}, "PLAIN", "guest\0guest\0", "en_GB"

  # Connection.Tune/Connection.Tune-Ok
  connection_tune_response = socket.decode
  channel_max = connection_tune_response.channel_max
  frame_max   = connection_tune_response.frame_max
  heartbeat   = connection_tune_response.heartbeat
  socket.encode Connection::TuneOk, channel_max, frame_max, heartbeat
  puts "Max agreed frame size: #{frame_max}"

  # Connection.Open/Connection.Open-Ok
  socket.encode Connection::Open, "/"
  connection_open_ok_response = socket.decode

  # Channel.Open/Channel.Open-Ok
  socket.encode Channel::Open, 1, ""
  channel_open_ok_response = socket.decode

  # Exchange.Declare/Exchange.Declare-Ok
  socket.encode Exchange::Declare, 1, "tasks", "fanout", false, false, false, false, {}
  exchange_declare_ok_response = socket.decode

  # Queue.Declare/Queue.Declare-Ok
  socket.encode Queue::Declare, 1, "", false, false, false, false, {}
  queue_declare_ok_response = socket.decode

  queue_declare_ok_response.queue[-1] = "" ###
  puts "\e[1;31mFIXME: payload decoding doesn't work properly:\e[0m" ###

  puts "Queue name: #{queue_declare_ok_response.queue.inspect}"

  # Queue.Bind/Queue.Bind-Ok
  socket.encode Queue::Bind, 1, queue_declare_ok_response.queue, "tasks", "", {}
  queue_bind_ok_response = socket.decode

  # Basic.Consume
  socket.encode Basic::Consume, 1, queue_declare_ok_response.queue, "", false, false, false, Hash.new

  # Basic.Publish
  socket.encode Basic::Publish, 1, "this is a payload", {content_type: "text/plain"}, "tasks", "", false, false, frame_max

  # Consume data.
  consumed_data = socket.decode

  # Channel.Close/Channel.Close-Ok
  socket.encode Channel::Close, 1, 200, "bye", 0, 0
  channel_close_ok_response = socket.decode

  # Connection.Close/Connection.Close-Ok
  socket.encode Connection::Close, 200, "", 0, 0
  # are these good args?
  # reply_code, reply_text, class_id, method_id = 200, "", 0, 0
  close_ok_response = socket.decode
rescue Exception => exception
  STDERR.puts "\n\e[1;31m[#{exception.class}] #{exception.message}\e[0m"
  exception.backtrace.each do |line|
    line = "\e[0;36m#{line}\e[0m" if line.match(Regexp::quote(File.basename(__FILE__)))
    STDERR.puts "  - " + line
  end
  exit 1
ensure
  socket.close
end
