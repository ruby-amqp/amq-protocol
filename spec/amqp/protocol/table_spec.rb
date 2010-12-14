# encoding: utf-8

require_relative "../../spec_helper.rb"

describe AMQP::Protocol::Table do
  describe ".encode" do
    # TODO: which endian should be used, does it matter? http://pastie.org/1362275
    DATA = {
      nil               => "\x00\x00\x00\x00",
      Hash.new          => "\x00\x00\x00\x00",
      {test: true}      => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
      {test: 1}         => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
      {test: "string"}  => "\x00\x00\x00\x10\x04testS\x00\x00\x00\x06string",
      {test: Hash.new}  => "\x00\x00\x00\n\x04testF\x00\x00\x00\x00",
    }

    DATA.each do |data, encoded|
      it "should return #{encoded.inspect} for #{data.inspect}" do
        AMQP::Protocol::Table.encode(data).should eql(encoded)
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
