#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "amq/protocol/client"
require "benchmark/ips"

puts
puts "-" * 80
puts "Pack/Unpack Micro-benchmarks on #{RUBY_DESCRIPTION}"
puts "-" * 80

# Test data
UINT64_VALUE = 0x123456789ABCDEF0
UINT32_VALUE = 0x12345678
UINT16_VALUE = 0x1234

PACKED_UINT64_BE = (+"\x12\x34\x56\x78\x9A\xBC\xDE\xF0").force_encoding('BINARY').freeze
PACKED_UINT32_BE = (+"\x12\x34\x56\x78").force_encoding('BINARY').freeze
PACKED_UINT16_BE = (+"\x12\x34").force_encoding('BINARY').freeze

puts "=== Pack Operations ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("AMQ::Pack.pack_uint64_big_endian") do
    AMQ::Pack.pack_uint64_big_endian(UINT64_VALUE)
  end

  # Alternative: direct pack with 'Q>' directive (Ruby 1.9.3+)
  x.report("[val].pack('Q>')") do
    [UINT64_VALUE].pack('Q>')
  end

  x.report("[val].pack('N') uint32") do
    [UINT32_VALUE].pack('N')
  end

  x.report("[val].pack('n') uint16") do
    [UINT16_VALUE].pack('n')
  end

  x.compare!
end

puts
puts "=== Unpack Operations ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("AMQ::Pack.unpack_uint64_big_endian") do
    AMQ::Pack.unpack_uint64_big_endian(PACKED_UINT64_BE)
  end

  # Alternative: direct unpack with 'Q>' directive
  x.report("data.unpack('Q>')") do
    PACKED_UINT64_BE.unpack('Q>')
  end

  x.report("data.unpack1('Q>')") do
    PACKED_UINT64_BE.unpack1('Q>')
  end

  x.report("data.unpack('N').first") do
    PACKED_UINT32_BE.unpack('N').first
  end

  x.report("data.unpack1('N')") do
    PACKED_UINT32_BE.unpack1('N')
  end

  x.compare!
end

puts
puts "=== String Slicing ==="

DATA = ("x" * 1000).force_encoding('BINARY').freeze

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("data[offset, length]") do
    DATA[100, 50]
  end

  x.report("data.byteslice(offset, length)") do
    DATA.byteslice(100, 50)
  end

  x.report("data.slice(offset, length)") do
    DATA.slice(100, 50)
  end

  x.compare!
end

puts
puts "=== Single Byte Access ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("data[0, 1].unpack('C').first") do
    DATA[0, 1].unpack('C').first
  end

  x.report("data.getbyte(0)") do
    DATA.getbyte(0)
  end

  x.report("data[0].ord") do
    DATA[0].ord
  end

  x.report("data.unpack1('C')") do
    DATA.unpack1('C')
  end

  x.compare!
end

puts
puts "=== Buffer Building ==="

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("String.new + <<") do
    buf = String.new
    buf << "hello"
    buf << "world"
    buf << [1234].pack('N')
    buf
  end

  x.report("+'' + <<") do
    buf = +''
    buf << "hello"
    buf << "world"
    buf << [1234].pack('N')
    buf
  end

  x.report("Array#join") do
    parts = []
    parts << "hello"
    parts << "world"
    parts << [1234].pack('N')
    parts.join
  end

  x.compare!
end
