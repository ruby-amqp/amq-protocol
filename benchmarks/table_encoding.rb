#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "amq/protocol/client"
require "benchmark/ips"

puts
puts "-" * 80
puts "Table Encoding/Decoding Benchmarks on #{RUBY_DESCRIPTION}"
puts "-" * 80

# Test data - various table sizes and types
EMPTY_TABLE = {}

SIMPLE_TABLE = {
  "key1" => "value1",
  "key2" => 42,
  "key3" => true
}.freeze

TYPICAL_HEADERS = {
  "content_type" => "application/json",
  "content_encoding" => "utf-8",
  "x-custom-header" => "some-value",
  "x-retry-count" => 3,
  "x-timestamp" => Time.now.to_i
}.freeze

COMPLEX_TABLE = {
  "string" => "hello world",
  "integer" => 123456789,
  "float" => 3.14159,
  "boolean_true" => true,
  "boolean_false" => false,
  "nested" => {
    "inner_key" => "inner_value",
    "inner_number" => 999
  },
  "array" => [1, 2, 3, "four", true]
}.freeze

LARGE_TABLE = (1..50).to_h { |i| ["key_#{i}", "value_#{i}"] }.freeze

# Pre-encode tables for decode benchmarks
ENCODED_EMPTY = AMQ::Protocol::Table.encode(EMPTY_TABLE)
ENCODED_SIMPLE = AMQ::Protocol::Table.encode(SIMPLE_TABLE)
ENCODED_TYPICAL = AMQ::Protocol::Table.encode(TYPICAL_HEADERS)
ENCODED_COMPLEX = AMQ::Protocol::Table.encode(COMPLEX_TABLE)
ENCODED_LARGE = AMQ::Protocol::Table.encode(LARGE_TABLE)

puts "Table sizes (bytes): empty=#{ENCODED_EMPTY.bytesize}, simple=#{ENCODED_SIMPLE.bytesize}, typical=#{ENCODED_TYPICAL.bytesize}, complex=#{ENCODED_COMPLEX.bytesize}, large=#{ENCODED_LARGE.bytesize}"
puts

puts "=== Table Encoding ==="
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("encode empty") do
    AMQ::Protocol::Table.encode(EMPTY_TABLE)
  end

  x.report("encode simple (3 keys)") do
    AMQ::Protocol::Table.encode(SIMPLE_TABLE)
  end

  x.report("encode typical headers (5 keys)") do
    AMQ::Protocol::Table.encode(TYPICAL_HEADERS)
  end

  x.report("encode complex (nested/array)") do
    AMQ::Protocol::Table.encode(COMPLEX_TABLE)
  end

  x.report("encode large (50 keys)") do
    AMQ::Protocol::Table.encode(LARGE_TABLE)
  end

  x.compare!
end

puts
puts "=== Table Decoding ==="
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("decode empty") do
    AMQ::Protocol::Table.decode(ENCODED_EMPTY)
  end

  x.report("decode simple (3 keys)") do
    AMQ::Protocol::Table.decode(ENCODED_SIMPLE)
  end

  x.report("decode typical headers (5 keys)") do
    AMQ::Protocol::Table.decode(ENCODED_TYPICAL)
  end

  x.report("decode complex (nested/array)") do
    AMQ::Protocol::Table.decode(ENCODED_COMPLEX)
  end

  x.report("decode large (50 keys)") do
    AMQ::Protocol::Table.decode(ENCODED_LARGE)
  end

  x.compare!
end
