require 'time'
require "amq/protocol/table_value_decoder"

module AMQ
  module Protocol
    RSpec.describe TableValueDecoder do

      it "is capable of decoding basic arrays TableValueEncoder encodes" do
        input1 = [1, 2, 3]

        value, _offset = described_class.decode_array(TableValueEncoder.encode(input1), 1)
        expect(value.size).to eq(3)
        expect(value.first).to eq(1)
        expect(value).to eq(input1)



        input2 = ["one", 2, "three"]

        value, _offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        expect(value.size).to eq(3)
        expect(value.first).to eq("one")
        expect(value).to eq(input2)



        input3 = ["one", 2, "three", 4.0, 5000000.0]

        value, _offset = described_class.decode_array(TableValueEncoder.encode(input3), 1)
        expect(value.size).to eq(5)
        expect(value.last).to eq(5000000.0)
        expect(value).to eq(input3)
      end



      it "is capable of decoding arrays TableValueEncoder encodes" do
        input1 = [{ "one" => 2 }, 3]
        data1  = TableValueEncoder.encode(input1)

        # puts(TableValueEncoder.encode({ "one" => 2 }).inspect)
        # puts(TableValueEncoder.encode(input1).inspect)


        value, _offset = described_class.decode_array(data1, 1)
        expect(value.size).to eq(2)
        expect(value.first).to eq(Hash["one" => 2])
        expect(value).to eq(input1)



        input2 = ["one", 2, { "three" => { "four" => 5.0 } }]

        value, _offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        expect(value.size).to eq(3)
        expect(value.last["three"]["four"]).to eq(5.0)
        expect(value).to eq(input2)
      end

      it "is capable of decoding 32 bit float values" do
        input = Float32Bit.new(10.0)
        data  = TableValueEncoder.encode(input)

        value = described_class.decode_32bit_float(data, 1)[0]
        expect(value).to eq(10.0)
      end

      context "8bit/byte decoding" do
        let(:examples) {
          {
              0x00 => "\x00",
              0x01 => "\x01",
              0x10 => "\x10",
              255   => "\xFF" # not -1
          }
        }

        it "is capable of decoding byte values" do
          examples.each do |key, value|
            expect(described_class.decode_byte(value, 0).first).to eq(key)
          end
        end
      end

      describe ".decode_string" do
        it "decodes string values" do
          # 4 bytes length + string content
          data = "\x00\x00\x00\x05hello"
          value, offset = described_class.decode_string(data, 0)
          expect(value).to eq("hello")
          expect(offset).to eq(9)
        end
      end

      describe ".decode_integer" do
        it "decodes 32-bit unsigned integers" do
          data = "\x00\x00\x00\x0A"
          value, offset = described_class.decode_integer(data, 0)
          expect(value).to eq(10)
          expect(offset).to eq(4)
        end
      end

      describe ".decode_long" do
        it "decodes 64-bit signed integers" do
          data = "\x00\x00\x00\x00\x00\x00\x00\x0A"
          value, offset = described_class.decode_long(data, 0)
          expect(value).to eq(10)
          expect(offset).to eq(8)
        end
      end

      describe ".decode_time" do
        it "decodes timestamp values" do
          timestamp = Time.now.to_i
          data = [timestamp].pack('Q>')
          value, offset = described_class.decode_time(data, 0)
          expect(value.to_i).to eq(timestamp)
          expect(offset).to eq(8)
        end
      end

      describe ".decode_boolean" do
        it "decodes true" do
          value, offset = described_class.decode_boolean("\x01", 0)
          expect(value).to eq(true)
          expect(offset).to eq(1)
        end

        it "decodes false" do
          value, offset = described_class.decode_boolean("\x00", 0)
          expect(value).to eq(false)
          expect(offset).to eq(1)
        end
      end

      describe ".decode_64bit_float" do
        it "decodes 64-bit floats" do
          data = [3.14159].pack('G')
          value, offset = described_class.decode_64bit_float(data, 0)
          expect(value).to be_within(0.00001).of(3.14159)
          expect(offset).to eq(8)
        end
      end

      describe ".decode_value_type" do
        it "returns the type byte and incremented offset" do
          data = "Shello"
          type, offset = described_class.decode_value_type(data, 0)
          expect(type).to eq("S")
          expect(offset).to eq(1)
        end
      end

      describe ".decode_short" do
        it "decodes 16-bit signed integers" do
          data = "\x06\x8D"
          value, offset = described_class.decode_short(data, 0)
          expect(value).to eq(1677)
          expect(offset).to eq(2)
        end
      end

      describe ".decode_big_decimal" do
        it "decodes BigDecimal values" do
          # Scale 2, raw value 100 = 1.00
          data = "\x02\x00\x00\x00\x64"
          value, offset = described_class.decode_big_decimal(data, 0)
          expect(value).to be_a(BigDecimal)
          expect(offset).to eq(5)
        end
      end

      describe ".decode_hash" do
        it "decodes nested hash values" do
          encoded = AMQ::Protocol::Table.encode({"nested" => "value"})
          value, _offset = described_class.decode_hash(encoded, 0)
          expect(value).to eq({"nested" => "value"})
        end
      end
    end
  end
end
