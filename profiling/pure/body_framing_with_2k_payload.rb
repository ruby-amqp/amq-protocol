#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require "amq/protocol/client"

FRAME_SIZE = 128 * 1024

puts
puts "-" * 80
puts "Profiling on #{RUBY_DESCRIPTION}"

n = 250_000

# warm up the JIT, etc
puts "Doing a warmup run..."
15_000.times { AMQ::Protocol::Method.encode_body("ab" * 1024, 1, FRAME_SIZE) }

require 'ruby-prof'

# preallocate
ary = Array.new(n) { "ab" * 1024 }

puts "Doing main run..."
result = RubyProf.profile do
  n.times { |i| AMQ::Protocol::Method.encode_body(ary[i], 1, FRAME_SIZE) }
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, {})

