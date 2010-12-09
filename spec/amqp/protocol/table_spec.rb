# encoding: utf-8

require_relative "../../spec_helper.rb"

describe AMQP::Protocol::Table do
  describe ".encode" do
    # TODO: which endian should be used, does it matter? http://pastie.org/1362275
    DATA = {
      nil                                  => ["\x00\x00\x00\x00"],
      Hash.new                             => ["\x00\x00\x00\x00"],
      {test: true}                         => ["\n\x00\x00\x00",   "\x04", "test", "I\x01\x00\x00\x00"],
      {test: 1}                            => ["\n\x00\x00\x00",   "\x04", "test", "I\x01\x00\x00\x00"],
      {test: "string"}                     => ["\x10\x00\x00\x00", "\x04", "test", "S\x06\x00\x00\x00", "string"],
      {test: Hash.new}                     => ["\n\x00\x00\x00",   "\x04", "test", "F", "\x00\x00\x00\x00"],
      # {test: true}                         => ["\x00\x00\x00\n",   "\x04", "test", "I\x00\x00\x00\x01"],
      # {test: 1}                            => ["\x00\x00\x00\n",   "\x04", "test", "I\x00\x00\x00\x01"],
      # {test: "string"}                     => ["\x00\x00\x00\x10", "\x04", "test", "S\x00\x00\x00\x06", "string"],
      # {test: Hash.new}                     => ["\x00\x00\x00\n",   "\x04", "test", "F", "\x00\x00\x00\x00"],
      # {a: 1, c: true, d: "x", e: Hash.new} => ["\x00\x00\x00\x1d", "\x01", "a", "I\x00\x00\x00\x01", "\x01", "c", "I\x00\x00\x00\x01", "\x01", "e", "F", "\x00\x00\x00\x00", "\x01", "d", "S\x00\x00\x00\x01", "x"]
    }

    DATA.each do |data, encoded|
      it "should return #{encoded.inspect} for #{data.inspect}" do
        AMQP::Protocol::Table.encode(Array.new, data).last.should eql(encoded)
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
