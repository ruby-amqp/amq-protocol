# encoding: binary

require_relative "../../spec_helper.rb"
require "stringio"

describe AMQP::Protocol::Frame do
  describe ".encode" do
    it "should raise ConnectionError if type isn't one of: [:method, :header, :body, :heartbeat]" do
      -> { Frame.encode(nil, 0, "") }.should raise_error(ConnectionError, "Must be one of [:method, :header, :body, :heartbeat]")
    end

    it "should raise RuntimeError if channel isn't 0 or an integer in range 1..65535" do
      -> { Frame.encode(:method, -1, "") }.should raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      -> { Frame.encode(:method, 65536, "") }.should raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      -> { Frame.encode(:method, 65535, "") }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      -> { Frame.encode(:method, 0, "") }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
      -> { Frame.encode(:method, 1, "") }.should_not raise_error(RuntimeError, "Channel has to be 0 or an integer in range 1..65535")
    end

    it "should raise RuntimeError if payload is nil" do
      -> { Frame.encode(:method, 0, nil) }.should raise_error(RuntimeError, "Payload can't be nil")
    end

    it "should encode type" do
      Frame.encode(:body, 0, "").unpack("c").first.should eql(3)
    end

    it "should encode channel" do
      Frame.encode(:body, 12, "").unpack("cn").last.should eql(12)
    end

    it "should encode size" do
      Frame.encode(:body, 12, "test").unpack("cnN").last.should eql(4)
    end

    it "should include payload" do
      Frame.encode(:body, 12, "test")[7..-2].should eql("test")
    end

    it "should include final octet" do
      Frame.encode(:body, 12, "test")[-1].should eql("\xCE")
    end
  end

  describe ".new" do
    before(:each) do
      @data = Frame.encode(:body, 5, "test")
      @readable = StringIO.new(@data)
    end

    it "should decode type" do
      Frame.decode(@readable).type.should eql(:body)
    end

    it "should decode size" do
      Frame.decode(@readable).size.should eql(4)
    end

    it "should decode channel" do
      Frame.decode(@readable).channel.should eql(5)
    end

    it "should decode payload" do
      Frame.decode(@readable).payload.should eql("test")
    end

    it "should raise RuntimeError if the size is bigger than the actual size" do
      pending
      invalid_data = @data.dup
      invalid_data[3..6] = [5].pack("N")
      readable = StringIO.new(invalid_data)
      -> { Frame.decode(readable) }.should raise_error(RuntimeError, "Frame doesn't end with \xCE as it must, which means the size is miscalculated.")
    end

    it "should raise RuntimeError if the size is smaller than the actual size" do
      invalid_data = @data.dup
      invalid_data[3..6] = [3].pack("N")
      readable = StringIO.new(invalid_data)
      -> { Frame.decode(readable) }.should raise_error(RuntimeError, "Frame doesn't end with \xCE as it must, which means the size is miscalculated.")
    end
  end
end
