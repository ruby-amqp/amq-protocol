#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

require File.expand_path("../lib/amq/protocol/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "amq-protocol"
  s.version = AMQ::Protocol::VERSION
  s.authors = ["Jakub Stastny", "Michael S. Klishin", "Theo Hultberg", "Mark Abramov"]
  s.homepage = "http://github.com/ruby-amqp/amq-protocol"
  s.summary = "AMQP 0.9.1 encoder & decoder."
  s.description = "This is an AMQP encoder & decoder for AMQP 0.9.1. It isn't an AMQP client, just the parser, so if you want to write your own AMQP client without digging into the protocol, this gem can help you with that."
  s.cert_chain = nil
  s.email = ["bWljaGFlbEBub3ZlbWJlcmFpbi5jb20=\n", "c3Rhc3RueUAxMDFpZGVhcy5jeg==\n"].map { |i| Base64.decode64(i) }
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n").reject { |file| file =~ /^vendor\// }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README.textile"] + Dir.glob("doc/*")


  begin
    require "changelog"
    s.post_install_message = CHANGELOG.new.version_changes
  rescue LoadError
    # warn "You have to have changelog gem installed for post install message"
  end

  # RubyForge
  s.rubyforge_project = "amq-protocol"
end
