#!/usr/bin/env ruby
# encoding: utf-8

# This file is supposed to make inspecting AMQ protocol easier.

# How does it work:
# 1) This file is executed.
# 2) We load irb, redefine where IRB looks for .irbrc and start IRB.
# 3) IRB loads .irbrc, which we redefined, so it loads this file again.
#    However now the second branch of "if __FILE__ == $0" gets executed,
#    so it runs our custom code which loads the original .irbrc and then
#    it redefines some IRB settings. In this case it add IRB hook which
#    is executed after IRB is started.

# Although it looks unnecessarily complicated, I can't see any easier
# solution to this problem in case that you need to patch original settings.
# Obviously in case you don't have the need, you'll be happy with simple:

# require "irb"
#
# require_relative "lib/amq/protocol/client.rb"
# include AMQ::Protocol
#
# IRB.start(__FILE__)

require "irb"

if __FILE__ == $0
  puts "~ Using #{__FILE__} as an executable ..."

  def IRB.rc_file_generators
    yield Proc.new { |_| __FILE__ }
  end

  IRB.start(__FILE__)
else
  irbrc = File.join(ENV["HOME"], ".irbrc")
  puts "~ Using #{__FILE__} as a custom .irbrc .."
  puts "~ Loading original #{irbrc} ..."
  load irbrc

  require_relative "lib/amq/protocol/client.rb"
  include AMQ::Protocol

  require "stringio"

  def fd(data)
    Frame.decode(StringIO.new(data))
  end
end
