# encoding: binary

RSpec.describe AMQ::Protocol::Error do
  describe ".[]" do
    it "looks up exception class by error code" do
      # This only works if subclasses define VALUE constant
      # Default case: no subclass with VALUE defined returns nil
      expect { described_class[999999] }.to raise_error(/No such exception class/)
    end
  end

  describe ".subclasses_with_values" do
    it "returns subclasses that define VALUE constant" do
      result = described_class.subclasses_with_values
      expect(result).to be_an(Array)
    end
  end

  describe "#initialize" do
    it "uses default message when none provided" do
      error = described_class.new
      expect(error.message).to eq("AMQP error")
    end

    it "uses custom message when provided" do
      error = described_class.new("Custom error")
      expect(error.message).to eq("Custom error")
    end
  end
end

RSpec.describe AMQ::Protocol::FrameTypeError do
  it "formats message with valid types" do
    error = described_class.new([:method, :headers])
    expect(error.message).to include("[:method, :headers]")
  end
end

RSpec.describe AMQ::Protocol::EmptyResponseError do
  it "has a default message" do
    error = described_class.new
    expect(error.message).to eq("Empty response received from the server.")
  end

  it "accepts custom message" do
    error = described_class.new("Custom empty response")
    expect(error.message).to eq("Custom empty response")
  end
end

RSpec.describe AMQ::Protocol::BadResponseError do
  it "formats message with argument, expected, and actual values" do
    error = described_class.new("channel", 1, 2)
    expect(error.message).to include("channel")
    expect(error.message).to include("1")
    expect(error.message).to include("2")
  end
end

RSpec.describe AMQ::Protocol::SoftError do
  it "is a subclass of Protocol::Error" do
    expect(described_class.superclass).to eq(AMQ::Protocol::Error)
  end
end

RSpec.describe AMQ::Protocol::HardError do
  it "is a subclass of Protocol::Error" do
    expect(described_class.superclass).to eq(AMQ::Protocol::Error)
  end
end
