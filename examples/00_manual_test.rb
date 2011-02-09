#!/usr/bin/env ruby
# encoding: utf-8

# Usage:
#   ./examples/00_manual_test.rb
#   ./examples/00_manual_test.rb 5673

require "socket"
require_relative "../lib/amq/protocol/client.rb"

include AMQ::Protocol

# Stolen from amq-client:
class AMQ::Protocol::Frame
  def self.decode(io)
    header = io.read(7)
    type, channel, size = self.decode_header(header)
    data = io.read(size + 1)
    payload, frame_end = data[0..-2], data[-1]

    if frame_end != FINAL_OCTET
      raise "Frame has to end with #{FINAL_OCTET.inspect}!"
    end

    self.new(type, payload, channel)
  end
end

# NOTE: this doesn't work with "localhost", I don't know why:
socket   = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
sockaddr = Socket.pack_sockaddr_in((ARGV.first || 5672).to_i, "127.0.0.1")

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
  socket.encode Connection::StartOk, {client: "AMQ Protocol"}, "PLAIN", "\0guest\0guest", "en_GB"

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

  begin
    # Channel.Open/Channel.Open-Ok
    socket.encode Channel::Open, 1, ""
    channel_open_ok_response = socket.decode

    begin
      # Exchange.Declare/Exchange.Declare-Ok
      socket.encode Exchange::Declare, 1, "tasks", "fanout", false, false, false, false, false, {}
      exchange_declare_ok_response = socket.decode

      # Queue.Declare/Queue.Declare-Ok
      socket.encode Queue::Declare, 1, "", false, false, false, false, false, {}
      queue_declare_ok_response = socket.decode

      puts "Queue name: #{queue_declare_ok_response.queue.inspect}"

      # Queue.Bind/Queue.Bind-Ok
      socket.encode Queue::Bind, 1, queue_declare_ok_response.queue, "tasks", "", false, {}
      queue_bind_ok_response = socket.decode

      # Basic.Consume
      socket.encode Basic::Consume, 1, queue_declare_ok_response.queue, "", false, false, false, false, Hash.new

      # Basic.Publish
      socket.encode Basic::Publish, 1, "this is a payload", {content_type: "text/plain"}, "tasks", "", false, false, frame_max

      # Basic.Consume-Ok
      basic_consume_ok_response = socket.decode
      puts "Consumed successfully, consumer tag: #{basic_consume_ok_response.consumer_tag}"

      # Basic.Deliver
      basic_deliver        = socket.decode
      basic_deliver_header = socket.decode # header frame: {}
      basic_deliver_body   = socket.decode # body frame: "this is a payload"
      puts "[Received] headers: #{basic_deliver_header.inspect}, payload: #{basic_deliver_body.inspect}"
    ensure
      # Channel.Close/Channel.Close-Ok
      socket.encode Channel::Close, 1, 200, "bye", 0, 0
      channel_close_ok_response = socket.decode
    end
  ensure
    # Connection.Close/Connection.Close-Ok
    socket.encode Connection::Close, 200, "", 0, 0
    close_ok_response = socket.decode
  end
rescue Exception => exception
  STDERR.puts "\n\e[1;31m[#{exception.class}] #{exception.message}\e[0m"
  exception.backtrace.each do |line|
    line = "\e[0;36m#{line}\e[0m" if line.match(Regexp::quote(File.basename(__FILE__)))
    STDERR.puts "  - " + line
  end
  exit 1 # Yes, this works with the ensure block, even though the rescue block run first. Magic.
ensure
  socket.close
end
