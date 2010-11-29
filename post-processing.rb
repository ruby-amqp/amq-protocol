#!/usr/bin/env ruby -i
# encoding: utf-8

# helpers
def pass; end

# main
buffer = ARGF.inject(String.new) do |buffer, line|
  # line filters
  line.gsub!(/\s*\n$/, "\n")

  buffer += line
end

# buffer filters
buffer.gsub!(/\n{2,}/m, "\n\n")
pass while buffer.gsub!(/(\n( *)  end)\n{2,}(\2end)/m, "\\1\n\\3")

puts buffer
