# encoding: binary

require "spec_helper"
require "stringio"

describe AMQ::Protocol::Frame do
  describe ".encode" do
    it "should raise FrameTypeError if type isn't one of: [:method, :header, :body, :heartbeat]" do
      lambda { AMQ::Protocol::Frame.encode(nil, "", 0) }.should raise_error(AMQ::Protocol::FrameTypeError)
    end

    it "should raise RuntimeError if channel isn't 0 or an integer in range 1..65535" do
      lambda { AMQ::Protocol::Frame.encode(:method, "", -1) }.should raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      lambda { AMQ::Protocol::Frame.encode(:method, "", 65536) }.should raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      lambda { AMQ::Protocol::Frame.encode(:method, "", 65535) }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      lambda { AMQ::Protocol::Frame.encode(:method, "", 0) }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      lambda { AMQ::Protocol::Frame.encode(:method, "", 1) }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
    end

    it "should raise RuntimeError if payload is nil" do
      lambda { AMQ::Protocol::Frame.encode(:method, nil, 0) }.should raise_error(RuntimeError, "Payload can't be nil")
    end

    it "should encode type" do
      AMQ::Protocol::Frame.encode(:body, "", 0).unpack("c").first.should eql(3)
    end

    it "should encode channel" do
      AMQ::Protocol::Frame.encode(:body, "", 12).unpack("cn").last.should eql(12)
    end

    it "should encode size" do
      AMQ::Protocol::Frame.encode(:body, "test", 12).unpack("cnN").last.should eql(4)
    end

    it "should include payload" do
      AMQ::Protocol::Frame.encode(:body, "test", 12)[7..-2].should eql("test")
    end

    it "should include final octet" do
      AMQ::Protocol::Frame.encode(:body, "test", 12).should =~ /\xCE$/
    end
  end

  describe ".new" do
    before(:each) do
      @data = AMQ::Protocol::Frame.encode(:body, "test", 5)
      @readable = StringIO.new(@data.to_s)
    end

    it "should raise RuntimeError if the size is bigger than the actual size" do
      pending
      invalid_data = @data.dup
      invalid_data[3..6] = [5].pack("N")
      readable = StringIO.new(invalid_data)
      lambda { AMQ::Protocol::Frame.decode(readable) }.should raise_error(RuntimeError, "describe AMQ::Protocol::Frame doesn't end with \xCE as it must, which means the size is miscalculated.")
    end

    it "should raise RuntimeError if the size is smaller than the actual size" do
      invalid_data = @data.dup
      puts invalid_data.inspect
      invalid_data[3..6] = [3].pack("N")
      readable = StringIO.new(invalid_data)
      lambda { AMQ::Protocol::Frame.decode(readable) }.should raise_error(NotImplementedError)
    end
  end
end
