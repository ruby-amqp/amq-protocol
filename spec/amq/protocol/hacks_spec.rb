require 'spec_helper'

describe AMQ::Hacks do
  context "64-bit big-endian packing / unpacking" do
    let(:examples) {
      {
        0x0000000000000000 => "\x00\x00\x00\x00\x00\x00\x00\x00",
        0x000000000000000A => "\x00\x00\x00\x00\x00\x00\x00\x0A",
        0x00000000000000A0 => "\x00\x00\x00\x00\x00\x00\x00\xA0",
        0x000000000000B0A0 => "\x00\x00\x00\x00\x00\x00\xB0\xA0",
        0x00000000000CB0AD => "\x00\x00\x00\x00\x00\x0C\xB0\xAD",
        0x8BADF00DDEFEC8ED => "\x8B\xAD\xF0\x0D\xDE\xFE\xC8\xED",
        0x0D15EA5EFEE1DEAD => "\x0D\x15\xEA\x5E\xFE\xE1\xDE\xAD",
        0xDEADBEEFDEADBABE => "\xDE\xAD\xBE\xEF\xDE\xAD\xBA\xBE"
      }
    }

    describe ".pack_64_big_endian" do
      it "packs integers into big-endian string" do
        examples.each do |key, value|
          described_class.pack_64_big_endian(key).should == value
        end
      end
    end

    describe ".unpack_64_big_endian" do
      it "should unpack string representation into integer" do
        examples.each do |key, value|
          described_class.unpack_64_big_endian(value)[0].should == key
        end
      end
    end
  end
end