#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

# Master benchmark runner
# Usage: ruby benchmarks/run_all.rb

require 'fileutils'

BENCHMARK_DIR = File.dirname(__FILE__)
RESULTS_DIR = File.join(BENCHMARK_DIR, "results")

FileUtils.mkdir_p(RESULTS_DIR)

benchmarks = %w[
  pack_unpack.rb
  frame_encoding.rb
  table_encoding.rb
  method_encoding.rb
]

timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
ruby_version = RUBY_VERSION.gsub('.', '_')
results_file = File.join(RESULTS_DIR, "benchmark_#{ruby_version}_#{timestamp}.txt")

puts "=" * 80
puts "AMQ-Protocol Benchmark Suite"
puts "=" * 80
puts "Ruby: #{RUBY_DESCRIPTION}"
puts "Time: #{Time.now}"
puts "Results will be saved to: #{results_file}"
puts "=" * 80
puts

File.open(results_file, 'w') do |f|
  f.puts "AMQ-Protocol Benchmark Results"
  f.puts "Ruby: #{RUBY_DESCRIPTION}"
  f.puts "Time: #{Time.now}"
  f.puts "=" * 80
  f.puts

  benchmarks.each do |benchmark|
    benchmark_path = File.join(BENCHMARK_DIR, benchmark)

    if File.exist?(benchmark_path)
      puts "\n>>> Running #{benchmark}..."
      puts

      output = `ruby #{benchmark_path} 2>&1`
      puts output

      f.puts ">>> #{benchmark}"
      f.puts output
      f.puts
    else
      puts "Warning: #{benchmark_path} not found, skipping..."
    end
  end
end

puts
puts "=" * 80
puts "Benchmark complete! Results saved to: #{results_file}"
puts "=" * 80
