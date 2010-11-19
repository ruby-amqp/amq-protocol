#!/usr/bin/env ruby
# encoding: utf-8

begin
  require "amqp/spec"
rescue LoadError
  abort "You have to install the amqp gem in order to run the benchmark against its AMQP encoder/decoder."
end

require "benchmark"

Benchmark.bmbm do |bm|
  bm.report("Raw binary") do
    # TODO
  end

  bm.report("AMQP Gem") do
    # TODO
  end

  bm.report("AMQP Protocol Gem") do
    # TODO
  end
end
