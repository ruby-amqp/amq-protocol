#!/usr/bin/env bundle exec ruby
# encoding: binary

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
  begin
    irbrc = File.join(ENV["HOME"], ".irbrc")
    puts "~ Using #{__FILE__} as a custom .irbrc .."
    puts "~ Loading original #{irbrc} ..."
    load irbrc

    # TODO: Don't generate constants in all.rb multiple
    # times, then we can remove this craziness with $VERBOSE.
    old_verbose, $VERBOSE = $VERBOSE, nil
    begin
      require_relative "lib/amq/protocol/all.rb"
    rescue LoadError
      abort "File lib/amq/protocol/all.rb doesn't exist! You have to generate it using ./tasks.rb generate --targets=all, executed from the root of AMQ Protocol repository."
    end
    $VERBOSE = old_verbose

    include AMQ::Protocol

    begin
      require "amq/client/framing/string/frame"

      class AMQ::Protocol::Frame
        def self.decode(string)
          AMQ::Client::Framing::String::Frame.decode(string)
        end
      end
    rescue LoadError
      warn "~ AMQ Client isn't available."
    end

    # "0123456789".chunks(1, 1, 2, 3)
    # => ["0", "1", "23", "456"]
    class String
      def chunks(*parts)
        offset = 0
        parts.map do |number_of_characters|
          self[offset..(offset + number_of_characters - 1)].tap do
            offset += number_of_characters
          end
        end << self[offset..-1]
      end
    end

    def fd(data)
      Frame.decode(data)
    end

    puts <<-EOF

This is an AMQP #{AMQ::Protocol::PROTOCOL_VERSION} console. You can:

  - Decode data via: fd(frame_data).
  - Encode data using AMQP classes directly:
      frame = Connection::Open.encode("/")
      frame.encode

    EOF
  rescue Exception => exception # it just discards all the exceptions!
    abort exception.message + "\n  - " + exception.backtrace.join("\n  - ")
  end
end
