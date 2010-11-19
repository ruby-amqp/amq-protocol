#!/usr/bin/env nake
# encoding: utf-8

Task.new(:generate) do |task|
  task.description = "Generate lib/amqp/protocol.rb"
  task.define do |opts, spec = "vendor/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"|
    sh "./codgen.py spec #{spec} lib/amqp/protocol.rb"
  end
end

Task.tasks.default = Task[:generate] # FIXME: it doesn't work now
