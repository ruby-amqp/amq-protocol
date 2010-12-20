# encoding: utf-8

require "bigdecimal"
require_relative "../../spec_helper.rb"

describe AMQ::Protocol::Table do
  timestamp    = Time.utc(2010, 12, 31, 23, 58, 59)
  bigdecimal_1 = BigDecimal.new("1.0")
  bigdecimal_2 = BigDecimal.new("5E-3")
  bigdecimal_3 = BigDecimal.new("-0.01")

  DATA = {
    Hash.new                 => "\x00\x00\x00\x00",
    {"test" => 1}            => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
    {"test" => "string"}     => "\x00\x00\x00\x10\x04testS\x00\x00\x00\x06string",
    {"test" => Hash.new}     => "\x00\x00\x00\n\x04testF\x00\x00\x00\x00",
    {"test" => bigdecimal_1} => "\x00\x00\x00\v\x04testD\x00\x00\x00\x00\x01",
    {"test" => bigdecimal_2} => "\x00\x00\x00\v\x04testD\x03\x00\x00\x00\x05",
    # {"test" => bigdecimal_3} => "\x00\x00\x00\v\x04testD\x02\x00\x00\x00\x00",
    {"test" => timestamp}    => "\x00\x00\x00\x0e\x04testT\x00\x00\x00\x00M\x1enC"
  }

  describe ".encode" do
    it "should return \"\x00\x00\x00\x00\" for nil" do
      Table.encode(nil).should eql("\x00\x00\x00\x00")
    end

    it "should return \"\x00\x00\x00\n\x04testI\x00\x00\x00\x01\" for {test: true}" do
      Table.encode(test: true).should eql("\x00\x00\x00\n\x04testI\x00\x00\x00\x01")
    end

    DATA.each do |data, encoded|
      it "should return #{encoded.inspect} for #{data.inspect}" do
        Table.encode(data).should eql(encoded)
      end
    end
  end

  describe ".decode" do
    DATA.each do |data, encoded|
      it "should return #{data.inspect} for #{encoded.inspect}" do
        Table.decode(encoded).should eql(data)
      end
    end
  end
end
