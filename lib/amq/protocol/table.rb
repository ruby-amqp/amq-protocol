# encoding: binary
# frozen_string_literal: true

require "amq/protocol/type_constants"
require "amq/protocol/table_value_encoder"
require "amq/protocol/table_value_decoder"

module AMQ
  module Protocol
    class Table

      #
      # Behaviors
      #

      include TypeConstants

      # Pack format string
      PACK_UINT32_BE = 'N'.freeze

      #
      # API
      #

      class InvalidTableError < StandardError
        def initialize(key, value)
          super("Invalid table value on key #{key}: #{value.inspect} (#{value.class})")
        end
      end


      def self.encode(table)
        buffer = +''

        table ||= {}

        table.each do |key, value|
          key = key.to_s # it can be a symbol as well
          buffer << key.bytesize.chr << key

          case value
          when Hash
            buffer << TYPE_HASH
            buffer << self.encode(value)
          else
            buffer << TableValueEncoder.encode(value).force_encoding(buffer.encoding)
          end
        end

        [buffer.bytesize].pack(PACK_UINT32_BE) << buffer
      end




      def self.decode(data)
        table        = {}
        table_length = data.unpack1(PACK_UINT32_BE)

        return table if table_length.zero?

        offset       = 4
        while offset <= table_length
          key, offset  = decode_table_key(data, offset)
          type, offset = TableValueDecoder.decode_value_type(data, offset)

          table[key] = case type
                       when TYPE_STRING
                         v, offset = TableValueDecoder.decode_string(data, offset)
                         v
                       when TYPE_BYTE_ARRAY
                         # Ruby doesn't have a direct counterpart to
                         # ByteBuffer or byte[], so using a string feels
                         # more appropriate than an array of fixnums
                         v, offset = TableValueDecoder.decode_string(data, offset)
                         v
                       when TYPE_INTEGER
                         v, offset = TableValueDecoder.decode_integer(data, offset)
                         v
                       when TYPE_DECIMAL
                         v, offset = TableValueDecoder.decode_big_decimal(data, offset)
                         v
                       when TYPE_TIME
                         v, offset = TableValueDecoder.decode_time(data, offset)
                         v
                       when TYPE_HASH
                         v, offset = TableValueDecoder.decode_hash(data, offset)
                         v
                       when TYPE_BOOLEAN
                         v, offset = TableValueDecoder.decode_boolean(data, offset)
                         v
                       when TYPE_BYTE
                         v, offset = TableValueDecoder.decode_byte(data, offset)
                         v
                       when TYPE_SIGNED_16BIT
                         v, offset = TableValueDecoder.decode_short(data, offset)
                         v
                       when TYPE_SIGNED_64BIT
                         v, offset = TableValueDecoder.decode_long(data, offset)
                         v
                       when TYPE_32BIT_FLOAT
                         v, offset = TableValueDecoder.decode_32bit_float(data, offset)
                         v
                       when TYPE_64BIT_FLOAT
                         v, offset = TableValueDecoder.decode_64bit_float(data, offset)
                         v
                       when TYPE_VOID
                         nil
                       when TYPE_ARRAY
                         v, offset = TableValueDecoder.decode_array(data, offset)
                         v
                       else
                         raise ArgumentError, "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}\nOffset: #{offset}\nTotal size: #{table_length}\nProcessed data: #{table.inspect}"
                       end
        end

        table
      end


      def self.length(data)
        data.unpack1(PACK_UINT32_BE)
      end


      def self.hash_size(value)
        acc = 0
        value.each do |k, v|
          acc += (1 + k.to_s.bytesize)
          acc += TableValueEncoder.field_value_size(v)
        end

        acc
      end


      def self.decode_table_key(data, offset)
        key_length = data.getbyte(offset)
        offset += 1
        key = data.byteslice(offset, key_length)
        offset += key_length

        [key, offset]
      end



    end # Table
  end # Protocol
end # AMQ
