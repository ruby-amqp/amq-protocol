# encoding: utf-8

require "bigdecimal"
require "spec_helper"

describe AMQ::Protocol::Table do
  timestamp    = Time.utc(2010, 12, 31, 23, 58, 59)
  bigdecimal_1 = BigDecimal.new("1.0")
  bigdecimal_2 = BigDecimal.new("5E-3")
  bigdecimal_3 = BigDecimal.new("-0.01")


  DATA = if one_point_eight?
           {
      Hash.new                 => "\000\000\000\000",
      {"test" => 1}            => "\000\000\000\n\004testI\000\000\000\001",
      {"test" => "string"}     => "\000\000\000\020\004testS\000\000\000\006string",
      {"test" => Hash.new}     => "\000\000\000\n\004testF\000\000\000\000",
      {"test" => bigdecimal_1} => "\000\000\000\v\004testD\000\000\000\000\001",
      {"test" => bigdecimal_2} => "\000\000\000\v\004testD\003\000\000\000\005",
      {"test" => timestamp}    => "\000\000\000\016\004testT\000\000\000\000M\036nC"
    }
         else
           {
      Hash.new                 => "\x00\x00\x00\x00",
      {"test" => 1}            => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
      {"test" => "string"}     => "\x00\x00\x00\x10\x04testS\x00\x00\x00\x06string",
      {"test" => Hash.new}     => "\x00\x00\x00\n\x04testF\x00\x00\x00\x00",
      {"test" => bigdecimal_1} => "\x00\x00\x00\v\x04testD\x00\x00\x00\x00\x01",
      {"test" => bigdecimal_2} => "\x00\x00\x00\v\x04testD\x03\x00\x00\x00\x05",
      {"test" => timestamp}    => "\x00\x00\x00\x0e\x04testT\x00\x00\x00\x00M\x1enC"
    }
         end

  describe ".encode" do
    it "should return \"\x00\x00\x00\x00\" for nil" do
      encoded_value = if one_point_eight?
                        "\000\000\000\000"
                      else
                        "\x00\x00\x00\x00"
                      end

      AMQ::Protocol::Table.encode(nil).should eql(encoded_value)
    end

    it "should return \"\x00\x00\x00\n\x04testI\x00\x00\x00\x01\" for {test: true}" do
      AMQ::Protocol::Table.encode(:test => true).should eql("\x00\x00\x00\n\x04testI\x00\x00\x00\x01")
    end

    DATA.each do |data, encoded|
      it "should return #{encoded.inspect} for #{data.inspect}" do
        AMQ::Protocol::Table.encode(data).should eql(encoded)
      end
    end
  end

  describe ".decode" do
    DATA.each do |data, encoded|
      it "should return #{data.inspect} for #{encoded.inspect}" do
        AMQ::Protocol::Table.decode(encoded).should eql(data)
      end
    end
  end
end
