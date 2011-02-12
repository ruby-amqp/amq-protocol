# -*- coding: utf-8 -*-
__dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))

puts __dir
$:.unshift(__dir) unless $:.include?(__dir)

require "amq/protocol/client"
require "amq/protocol/server"
