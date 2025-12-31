#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "amq/protocol/client"
require "benchmark/ips"

puts
puts "-" * 80
puts "AMQP Method Encoding/Decoding Benchmarks on #{RUBY_DESCRIPTION}"
puts "-" * 80

FRAME_SIZE = 131072  # 128KB, typical default

# Common message properties
BASIC_PROPERTIES = {
  content_type: "application/json",
  delivery_mode: 2,
  priority: 0,
  headers: { "x-custom" => "value" }
}.freeze

MINIMAL_PROPERTIES = {
  delivery_mode: 2
}.freeze

# Payloads
SMALL_BODY = '{"id":1}'.freeze
MEDIUM_BODY = ('x' * 1024).freeze
LARGE_BODY = ('x' * 65536).freeze

puts "=== Basic.Publish (Full Message Encoding) ==="
puts "This is the critical hot path for publishing messages"
puts

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("Publish small (8B) + minimal props") do
    AMQ::Protocol::Basic::Publish.encode(
      1,              # channel
      SMALL_BODY,     # payload
      MINIMAL_PROPERTIES,
      "",             # exchange
      "test.queue",   # routing_key
      false,          # mandatory
      false,          # immediate
      FRAME_SIZE
    )
  end

  x.report("Publish small (8B) + full props") do
    AMQ::Protocol::Basic::Publish.encode(
      1,
      SMALL_BODY,
      BASIC_PROPERTIES,
      "",
      "test.queue",
      false,
      false,
      FRAME_SIZE
    )
  end

  x.report("Publish medium (1KB) + full props") do
    AMQ::Protocol::Basic::Publish.encode(
      1,
      MEDIUM_BODY,
      BASIC_PROPERTIES,
      "",
      "test.queue",
      false,
      false,
      FRAME_SIZE
    )
  end

  x.report("Publish large (64KB) + full props") do
    AMQ::Protocol::Basic::Publish.encode(
      1,
      LARGE_BODY,
      BASIC_PROPERTIES,
      "",
      "test.queue",
      false,
      false,
      FRAME_SIZE
    )
  end

  x.compare!
end

# Create sample encoded methods for decoding benchmarks
puts
puts "=== Method Decoding ==="

# Simulate encoded Basic.Deliver frame payload (after class/method ID)
# Basic.Deliver: consumer_tag(shortstr), delivery_tag(longlong), redelivered(bit), exchange(shortstr), routing_key(shortstr)
def make_deliver_payload(consumer_tag, delivery_tag, exchange, routing_key)
  buffer = String.new(encoding: 'BINARY')
  buffer << consumer_tag.bytesize.chr
  buffer << consumer_tag
  buffer << AMQ::Pack.pack_uint64_big_endian(delivery_tag)
  buffer << "\x00"  # redelivered = false
  buffer << exchange.bytesize.chr
  buffer << exchange
  buffer << routing_key.bytesize.chr
  buffer << routing_key
  buffer
end

DELIVER_PAYLOAD_SHORT = make_deliver_payload("ctag", 1, "", "q")
DELIVER_PAYLOAD_TYPICAL = make_deliver_payload("bunny-consumer-12345", 999999, "amq.topic", "events.user.created")

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("Basic.Deliver.decode (short)") do
    AMQ::Protocol::Basic::Deliver.decode(DELIVER_PAYLOAD_SHORT)
  end

  x.report("Basic.Deliver.decode (typical)") do
    AMQ::Protocol::Basic::Deliver.decode(DELIVER_PAYLOAD_TYPICAL)
  end

  x.compare!
end

puts
puts "=== Properties Encoding/Decoding ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("encode_properties (minimal)") do
    AMQ::Protocol::Basic.encode_properties(100, MINIMAL_PROPERTIES)
  end

  x.report("encode_properties (full)") do
    AMQ::Protocol::Basic.encode_properties(1024, BASIC_PROPERTIES)
  end

  x.compare!
end

# Create encoded properties for decode benchmark
ENCODED_MINIMAL_PROPS = AMQ::Protocol::Basic.encode_properties(100, MINIMAL_PROPERTIES)
ENCODED_FULL_PROPS = AMQ::Protocol::Basic.encode_properties(1024, BASIC_PROPERTIES)

# Skip the first 12 bytes (class_id, weight, body_size)
PROPS_DATA_MINIMAL = ENCODED_MINIMAL_PROPS[12..-1]
PROPS_DATA_FULL = ENCODED_FULL_PROPS[12..-1]

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("decode_properties (minimal)") do
    AMQ::Protocol::Basic.decode_properties(PROPS_DATA_MINIMAL)
  end

  x.report("decode_properties (full)") do
    AMQ::Protocol::Basic.decode_properties(PROPS_DATA_FULL)
  end

  x.compare!
end

puts
puts "=== Other Common Methods ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("Basic.Ack.encode") do
    AMQ::Protocol::Basic::Ack.encode(1, 12345, false)
  end

  x.report("Basic.Nack.encode") do
    AMQ::Protocol::Basic::Nack.encode(1, 12345, false, true)
  end

  x.report("Basic.Reject.encode") do
    AMQ::Protocol::Basic::Reject.encode(1, 12345, true)
  end

  x.report("Queue.Declare.encode") do
    AMQ::Protocol::Queue::Declare.encode(1, "test.queue", false, true, false, false, false, {})
  end

  x.report("Exchange.Declare.encode") do
    AMQ::Protocol::Exchange::Declare.encode(1, "test.exchange", "topic", false, true, false, false, false, {})
  end

  x.compare!
end
