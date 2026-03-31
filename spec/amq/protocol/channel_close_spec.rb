# encoding: binary

module AMQ
  module Protocol
    class Channel
      RSpec.describe Close do
        describe "#delivery_ack_timeout?" do
          it "returns true for delivery acknowledgement timeout" do
            close = Close.new(406, "PRECONDITION_FAILED - delivery acknowledgement on channel 1 timed out. Timeout value used: 1800000 ms", 0, 0)
            expect(close.delivery_ack_timeout?).to be(true)
          end

          it "returns false for an unknown delivery tag" do
            close = Close.new(406, "PRECONDITION_FAILED - unknown delivery tag 82", 0, 0)
            expect(close.delivery_ack_timeout?).to be(false)
          end

          it "returns false for a different reply code" do
            close = Close.new(404, "NOT_FOUND - no queue", 0, 0)
            expect(close.delivery_ack_timeout?).to be(false)
          end
        end

        describe "#unknown_delivery_tag?" do
          it "returns true for an unknown delivery tag" do
            close = Close.new(406, "PRECONDITION_FAILED - unknown delivery tag 82", 0, 0)
            expect(close.unknown_delivery_tag?).to be(true)
          end

          it "returns false for a delivery ack timeout" do
            close = Close.new(406, "PRECONDITION_FAILED - delivery acknowledgement on channel 1 timed out. Timeout value used: 1800000 ms", 0, 0)
            expect(close.unknown_delivery_tag?).to be(false)
          end
        end

        describe "#message_too_large?" do
          it "returns true when message exceeds configured max size" do
            close = Close.new(406, "PRECONDITION_FAILED - message size 2000000 is larger than configured max size 1000000", 0, 0)
            expect(close.message_too_large?).to be(true)
          end

          it "returns false for an unknown delivery tag" do
            close = Close.new(406, "PRECONDITION_FAILED - unknown delivery tag 82", 0, 0)
            expect(close.message_too_large?).to be(false)
          end
        end
      end
    end
  end
end
