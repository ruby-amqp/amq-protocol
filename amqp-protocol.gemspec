#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "amqp-protocol"
  s.version = "0.0.1"
  s.authors = ["Jakub Stastny"]
  s.homepage = "http://github.com/botanicus/amqp-protocol"
  s.summary = "AMQP 0.9.1 encoder & decoder."
  s.description = "This is an AMQP encoder & decoder for AMQP 0.9.1. It isn't an AMQP client, just the parser, so if you want to write your own AMQP client without digging into the protocol, this gem can help you with that."
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "amqp-protocol"
end
