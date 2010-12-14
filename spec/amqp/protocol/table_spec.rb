# encoding: utf-8

require_relative "../../spec_helper.rb"

describe AMQP::Protocol::Table do
  DATA = {
    Hash.new              => "\x00\x00\x00\x00",
    {"test" => 1}         => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
    {"test" => "string"}  => "\x00\x00\x00\x10\x04testS\x00\x00\x00\x06string",
    {"test" => Hash.new}  => "\x00\x00\x00\n\x04testF\x00\x00\x00\x00",
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

__END__
# encode({"a":decimal.Decimal("1.0")})
# "\x00\x00\x00\x07\x01aD\x00\x00\x00\x00\x01"
#
# encode({"a":decimal.Decimal("5E-3")})
# "\x00\x00\x00\x07\x01aD\x03\x00\x00\x00\x05"
#
# encode({"a":datetime.datetime(2010,12,31,23,58,59)})
# "\x00\x00\x00\x0b\x01aT\x00\x00\x00\x00M\x1enC"
