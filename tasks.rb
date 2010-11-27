#!/usr/bin/env nake
# encoding: utf-8

Task.new(:generate) do |task|
  task.description = "Generate lib/amqp/protocol.rb"
  task.define do |opts, spec = nil|
    if spec.nil?
      spec = "vendor/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"
      unless File.exist?(spec)
        sh "git submodule init"
        sh "git submodule update"
      end
    end
    output = "lib/amqp/protocol.rb"
    sh "./codegen.py spec #{spec} #{output}"
    sh "./post-processing.rb #{output}"
    if File.file?(output)
      sh "ruby -c #{output}"
    end
  end
end

Task.tasks.default = Task[:generate] # FIXME: it doesn't work now
