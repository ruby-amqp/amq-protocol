# encoding: binary

require "amq/endianness"

RSpec.describe AMQ::Endianness do
  describe ".big_endian?" do
    it "returns a boolean" do
      expect([true, false]).to include(described_class.big_endian?)
    end
  end

  describe ".little_endian?" do
    it "returns the opposite of big_endian?" do
      expect(described_class.little_endian?).to eq(!described_class.big_endian?)
    end
  end

  describe "BIG_ENDIAN constant" do
    it "is a boolean" do
      expect([true, false]).to include(AMQ::Endianness::BIG_ENDIAN)
    end
  end
end
