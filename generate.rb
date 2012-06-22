#!/usr/bin/env ruby
# encoding: utf-8

def sh(*args)
  system(*args)
end

spec = "vendor/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"
unless File.exist?(spec)
  sh "git submodule update --init"
end

path = "lib/amq/protocol/client.rb"
sh "./codegen.py client #{spec} #{path}"
if File.file?(path)
  sh "./post-processing.rb #{path}"
  sh "ruby -c #{path}"
end
