# encoding: binary

RSpec.describe AMQ::Protocol::Float32Bit do
  describe "#initialize" do
    it "stores the value" do
      f = described_class.new(3.14)
      expect(f.value).to eq(3.14)
    end
  end

  describe "#value" do
    it "returns the stored value" do
      f = described_class.new(2.718)
      expect(f.value).to eq(2.718)
    end

    it "works with zero" do
      f = described_class.new(0.0)
      expect(f.value).to eq(0.0)
    end

    it "works with negative values" do
      f = described_class.new(-1.5)
      expect(f.value).to eq(-1.5)
    end
  end
end
