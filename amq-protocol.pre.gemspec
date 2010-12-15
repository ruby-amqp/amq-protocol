#!/usr/bin/env gem build
# encoding: utf-8

eval(File.read("amq-protocol.gemspec")).tap do |specification|
  specification.version = "#{specification.version}.pre"
end
