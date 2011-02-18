# -*- coding: utf-8 -*-
__dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))

$:.unshift(__dir) unless $:.include?(__dir)

require "amq/protocol/client"
