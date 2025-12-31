# encoding: binary

RSpec.describe AMQ::Pack do
  context "16-bit big-endian packing / unpacking" do
    let(:examples_16bit) {
      {
        0x068D => "\x06\x8D",  # 1677
        0x0000 => "\x00\x00",  # 0
        0x7FFF => "\x7F\xFF"   # 32767 (max positive signed 16-bit)
      }
    }

    it "packs signed integers into a big-endian string" do
      examples_16bit.each do |key, value|
        expect(described_class.pack_int16_big_endian(key)).to eq(value)
      end
    end

    it "unpacks signed integers from a string to a number" do
      examples_16bit.each do |key, value|
        expect(described_class.unpack_int16_big_endian(value)[0]).to eq(key)
      end
    end
  end

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

    it "packs integers into big-endian string" do
      examples.each do |key, value|
        expect(described_class.pack_uint64_big_endian(key)).to eq(value)
      end
    end

    it "unpacks string representation into integer" do
      examples.each do |key, value|
        expect(described_class.unpack_uint64_big_endian(value)[0]).to eq(key)
      end
    end
  end

  describe "AMQ::Hacks alias" do
    it "is an alias for AMQ::Pack (backwards compatibility)" do
      expect(AMQ::Hacks).to eq(AMQ::Pack)
    end
  end
end
