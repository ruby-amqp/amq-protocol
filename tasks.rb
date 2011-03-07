#!/usr/bin/env nake
# encoding: utf-8

load "contributors.nake"

Task.new(:generate) do |task|
  task.description = "Generate lib/amq/protocol/client.rb"
  task.define do |opts, spec = nil|
    if spec.nil?
      spec = "vendor/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"
      unless File.exist?(spec)
        sh "git submodule update --init"
      end
    end

    %w{client server}.each do |type|
      path = "lib/amq/protocol/#{type}.rb"
      sh "./codegen.py #{type} #{spec} #{path}"
      if File.file?(path)
        sh "./post-processing.rb #{path}"
        sh "ruby -c #{path}"
      end
    end
  end
end

Task.tasks.default = Task[:generate] # FIXME: it doesn't work now
