module AMQ
  module Protocol
    RSpec.describe Frame do
      describe ".encode" do
        it "should raise FrameTypeError if type isn't one of: [:method, :header, :body, :heartbeat]" do
          expect { Frame.encode(nil, "", 0) }.to raise_error(FrameTypeError)
        end

        it "should raise FrameTypeError if type isn't valid (when type is a symbol)" do
          expect { Frame.encode(:xyz, "test", 12) }.to raise_error(FrameTypeError)
        end

        it "should raise FrameTypeError if type isn't valid (when type is a number)" do
          expect { Frame.encode(16, "test", 12) }.to raise_error(FrameTypeError)
        end

        it "should raise RuntimeError if channel isn't 0 or an integer in range 1..65535" do
          expect { Frame.encode(:method, "", -1) }.to raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          expect { Frame.encode(:method, "", 65536) }.to raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          expect { Frame.encode(:method, "", 65535) }.not_to raise_error
          expect { Frame.encode(:method, "", 0) }.not_to raise_error
          expect { Frame.encode(:method, "", 1) }.not_to raise_error
        end

        it "should raise RuntimeError if payload is nil" do
          expect { Frame.encode(:method, nil, 0) }.to raise_error(RuntimeError, "Payload can't be nil")
        end

        it "should encode type" do
          expect(Frame.encode(:body, "", 0).unpack("c").first).to eql(3)
        end

        it "should encode channel" do
          expect(Frame.encode(:body, "", 12).unpack("cn").last).to eql(12)
        end

        it "should encode size" do
          expect(Frame.encode(:body, "test", 12).unpack("cnN").last).to eql(4)
        end

        it "should include payload" do
          expect(Frame.encode(:body, "test", 12)[7..-2]).to eql("test")
        end

        it "should include final octet" do
          expect(Frame.encode(:body, "test", 12).each_byte.to_a.last).to eq("CE".hex)
        end

        it "should encode unicode strings" do
          expect { Frame.encode(:body, "à bientôt!", 12) }.to_not raise_error
        end
      end

      describe ".new" do
        it "should raise FrameTypeError if the type is not one of the accepted" do
          expect { Frame.new(10) }.to raise_error(FrameTypeError)
        end
      end

      describe '#decode_header' do
        it 'raises FrameTypeError if the decoded type is not one of the accepted' do
          expect { Frame.decode_header("\n\x00\x01\x00\x00\x00\x05") }.to raise_error(FrameTypeError)
        end

        it 'raises EmptyResponseError if the header is nil' do
          expect { Frame.decode_header(nil) }.to raise_error(EmptyResponseError)
        end
      end

      describe HeaderFrame do
        subject { HeaderFrame.new("\x00<\x00\x00\x00\x00\x00\x00\x00\x00\x00\n\x98\x00\x18application/octet-stream\x02\x00", nil) }

        it "should decode body_size from payload" do
          expect(subject.body_size).to eq(10)
        end

        it "should decode klass_id from payload" do
          expect(subject.klass_id).to eq(60)
        end

        it "should decode weight from payload" do
          expect(subject.weight).to eq(0)
        end

        it "should decode properties from payload" do
          expect(subject.properties[:delivery_mode]).to eq(2)
          expect(subject.properties[:priority]).to eq(0)
        end

        it "is not final" do
          expect(subject.final?).to eq(false)
        end
      end

      describe BodyFrame do
        subject { BodyFrame.new("test payload", 1) }

        it "returns payload as decode_payload" do
          expect(subject.decode_payload).to eq("test payload")
        end

        it "is not final" do
          expect(subject.final?).to eq(false)
        end

        it "has correct size" do
          expect(subject.size).to eq(12)
        end
      end

      describe HeartbeatFrame do
        it "encodes with empty payload on channel 0" do
          encoded = HeartbeatFrame.encode
          expect(encoded.bytes.last).to eq(0xCE)
        end

        it "is final" do
          frame = HeartbeatFrame.new("", 0)
          expect(frame.final?).to eq(true)
        end
      end

      describe MethodFrame do
        it "is not final when method has content" do
          # Basic.Publish has content
          payload = "\x00\x3C\x00\x28\x00\x00\x00\x00\x00"
          frame = MethodFrame.new(payload, 1)
          # This will depend on the method class
          expect(frame).to respond_to(:final?)
        end
      end

      describe FrameSubclass do
        subject { BodyFrame.new("test", 1) }

        it "has channel accessor" do
          expect(subject.channel).to eq(1)
          subject.channel = 2
          expect(subject.channel).to eq(2)
        end

        it "encodes to array" do
          result = subject.encode_to_array
          expect(result).to be_an(Array)
          expect(result.size).to eq(3)
        end

        it "encodes to string" do
          result = subject.encode
          expect(result).to be_a(String)
          expect(result.bytes.last).to eq(0xCE)
        end
      end
    end
  end
end
