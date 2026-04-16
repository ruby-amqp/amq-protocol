#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true
#
# Prints a before/after delta summary from two benchmark result files.
# Changes within ±5% are considered noise and hidden.
#
# Usage: ruby benchmarks/compare_results.rb <before.txt> <after.txt>

NOISE_THRESHOLD = 5.0

def parse_ips(file)
  results = {}
  in_comparison = false

  File.readlines(file).each do |line|
    in_comparison = true  if line.strip == "Comparison:"
    in_comparison = false if in_comparison && line.strip.empty?
    next unless in_comparison

    results[$1.strip] = $2.to_f if line =~ /^(.+?):\s+([\d.]+) i\/s/
  end

  results
end

before = parse_ips(ARGV[0])
after  = parse_ips(ARGV[1])

deltas = (before.keys & after.keys).filter_map do |name|
  b, a = before[name], after[name]
  pct  = ((a - b) / b * 100).round(1)
  pct.abs >= NOISE_THRESHOLD ? [name, pct] : nil
end.sort_by { |_, pct| -pct }

if deltas.empty?
  puts "  No changes beyond ±#{NOISE_THRESHOLD}% noise threshold"
else
  deltas.each do |name, pct|
    color = pct >= 0 ? "\e[32m" : "\e[31m"
    sign  = pct >= 0 ? "+" : ""
    puts "  #{("%-45s" % name)} #{color}#{sign}#{pct}%\e[0m"
  end
end
