#!/usr/bin/env bundle exec nake
# encoding: utf-8

load "contributors.nake"

# ./tasks.rb generate
# ./tasks.rb generate --targets=client,server
Task.new(:generate) do |task|
  task.description = "Generate lib/amq/protocol/client.rb"

  def task.check_validity_of_target(target)
    valid_choices = ["client", "server", "all"]
    unless valid_choices.include?(target)
      raise "Target can be one #{valid_choices.inspect}, not #{target.inspect}"
    end
  end

  task.define do |opts, spec = nil|
    opts[:targets] ||= ["client"]

    if spec.nil?
      spec = "vendor/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"
      unless File.exist?(spec)
        sh "git submodule update --init"
      end
    end

    opts[:targets].each do |type|
      task.check_validity_of_target(type)
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
