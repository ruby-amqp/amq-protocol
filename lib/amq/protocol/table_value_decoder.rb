# encoding: binary
# frozen_string_literal: true

require "amq/protocol/type_constants"
require "amq/protocol/float_32bit"

module AMQ
  module Protocol

    class TableValueDecoder

      #
      # Behaviors
      #

      include TypeConstants

      # Pack format strings use explicit endianness (available as of Ruby 1.9.3)
      PACK_UINT32_BE   = 'N'.freeze
      PACK_INT64_BE    = 'q>'.freeze
      PACK_INT16_BE    = 's>'.freeze
      PACK_UINT64_BE   = 'Q>'.freeze
      PACK_FLOAT32     = 'f'.freeze  # single precision float (native endian, matches encoder)
      PACK_FLOAT64     = 'G'.freeze  # big-endian double precision float
      PACK_UCHAR_UINT32 = 'CN'.freeze

      #
      # API
      #

      def self.decode_array(data, initial_offset)
        array_length = data.byteslice(initial_offset, 4).unpack1(PACK_UINT32_BE)

        ary    = []
        offset = initial_offset + 4

        while offset <= (initial_offset + array_length)
          type, offset = decode_value_type(data, offset)

          i = case type
              when TYPE_STRING
                v, offset = decode_string(data, offset)
                v
              when TYPE_BYTE_ARRAY
                # Ruby doesn't have a direct counterpart to
                # ByteBuffer or byte[], so using a string feels
                # more appropriate than an array of fixnums
                v, offset = decode_string(data, offset)
                v
              when TYPE_INTEGER
                v, offset = decode_integer(data, offset)
                v
              when TYPE_DECIMAL
                v, offset = decode_big_decimal(data, offset)
                v
              when TYPE_TIME
                v, offset = decode_time(data, offset)
                v
              when TYPE_HASH
                v, offset = decode_hash(data, offset)
                v
              when TYPE_BOOLEAN
                v, offset = decode_boolean(data, offset)
                v
              when TYPE_BYTE
                v, offset = decode_byte(data, offset)
                v
              when TYPE_SIGNED_16BIT
                v, offset = decode_short(data, offset)
                v
              when TYPE_SIGNED_64BIT
                v, offset = decode_long(data, offset)
                v
              when TYPE_32BIT_FLOAT
                v, offset = decode_32bit_float(data, offset)
                v
              when TYPE_64BIT_FLOAT
                v, offset = decode_64bit_float(data, offset)
                v
              when TYPE_VOID
                nil
              when TYPE_ARRAY
                v, offset = decode_array(data, offset)
                v
              else
                raise ArgumentError.new("unsupported type in a table value: #{type.inspect}, do not know how to decode!")
              end

          ary << i
        end


        [ary, initial_offset + array_length + 4]
      end


      def self.decode_string(data, offset)
        length = data.byteslice(offset, 4).unpack1(PACK_UINT32_BE)
        offset += 4
        v = data.byteslice(offset, length)
        offset += length

        [v, offset]
      end


      def self.decode_integer(data, offset)
        v = data.byteslice(offset, 4).unpack1(PACK_UINT32_BE)
        offset += 4

        [v, offset]
      end


      def self.decode_long(data, offset)
        v = data.byteslice(offset, 8).unpack1(PACK_INT64_BE)
        offset += 8
        [v, offset]
      end


      def self.decode_big_decimal(data, offset)
        decimals, raw = data.byteslice(offset, 5).unpack(PACK_UCHAR_UINT32)
        offset += 5
        v = BigDecimal(raw.to_s) * (BigDecimal(TEN) ** -decimals)

        [v, offset]
      end


      def self.decode_time(data, offset)
        timestamp = data.byteslice(offset, 8).unpack1(PACK_UINT64_BE)
        v = Time.at(timestamp)
        offset += 8

        [v, offset]
      end


      def self.decode_boolean(data, offset)
        byte = data.getbyte(offset)
        offset += 1
        [(byte == 1), offset]
      end


      def self.decode_32bit_float(data, offset)
        v = data.byteslice(offset, 4).unpack1(PACK_FLOAT32)
        offset += 4

        [v, offset]
      end


      def self.decode_64bit_float(data, offset)
        v = data.byteslice(offset, 8).unpack1(PACK_FLOAT64)
        offset += 8

        [v, offset]
      end


      def self.decode_value_type(data, offset)
        [data.byteslice(offset, 1), offset + 1]
      end


      def self.decode_hash(data, offset)
        length = data.byteslice(offset, 4).unpack1(PACK_UINT32_BE)
        v = Table.decode(data.byteslice(offset, length + 4))
        offset += 4 + length

        [v, offset]
      end


      # Decodes/Converts a byte value from the data at the provided offset.
      #
      # @param [String] data - Binary data string
      # @param [Integer] offset - The offset from which to read the byte
      # @return [Array] - The Integer value and new offset pair
      def self.decode_byte(data, offset)
        [data.getbyte(offset), offset + 1]
      end


      def self.decode_short(data, offset)
        v = data.byteslice(offset, 2).unpack1(PACK_INT16_BE)
        offset += 2
        [v, offset]
      end
    end # TableValueDecoder
  end # Protocol
end # AMQ
