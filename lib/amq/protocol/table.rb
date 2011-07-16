# encoding: binary

require "amq/protocol/client"
require "amq/protocol/encoding"
require "amq/protocol/value_encoder"
require "amq/protocol/value_decoder"

# We will need to introduce concept of mappings, because
# AMQP 0.9, 0.9.1 and RabbitMQ uses different letters for entities
# http://dev.rabbitmq.com/wiki/Amqp091Errata#section_3
module AMQ
  module Protocol
    class Table

      #
      # Behaviors
      #

      include Encoding


      #
      # API
      #

      class InvalidTableError < StandardError
        def initialize(key, value)
          super("Invalid table value on key #{key}: #{value.inspect} (#{value.class})")
        end
      end


      def self.encode(table)
        buffer = String.new
        table ||= {}
        table.each do |key, value|
          key = key.to_s # it can be a symbol as well
          buffer << key.bytesize.chr + key

          case value
          when Hash then
            buffer << TYPE_HASH
            buffer << self.encode(value)
          else
            buffer << AMQ::Protocol::ValueEncoder.encode(value)
          end
        end

        [buffer.bytesize].pack(PACK_UINT32) + buffer
      end




      def self.decode(data)
        table        = Hash.new
        table_length = data.unpack(PACK_UINT32).first

        return table if table_length.zero?

        offset       = 4
        while offset <= table_length
          key, offset  = decode_table_key(data, offset)
          type, offset = ValueDecoder.decode_value_type(data, offset)

          table[key] = case type
                       when TYPE_STRING
                         v, offset = ValueDecoder.decode_string(data, offset)
                         v
                       when TYPE_INTEGER
                         v, offset = ValueDecoder.decode_integer(data, offset)
                         v
                       when TYPE_DECIMAL
                         v, offset = ValueDecoder.decode_big_decimal(data, offset)
                         v
                       when TYPE_TIME
                         v, offset = ValueDecoder.decode_time(data, offset)
                         v
                       when TYPE_HASH
                         v, offset = ValueDecoder.decode_hash(data, offset)
                         v
                       when TYPE_BOOLEAN
                         v, offset = ValueDecoder.decode_boolean(data, offset)
                         v
                       when TYPE_SIGNED_8BIT then raise NotImplementedError.new
                       when TYPE_SIGNED_16BIT then raise NotImplementedError.new
                       when TYPE_SIGNED_64BIT then raise NotImplementedError.new
                       when TYPE_32BIT_FLOAT then
                         v, offset = ValueDecoder.decode_32bit_float(data, offset)
                         v
                       when TYPE_64BIT_FLOAT then
                         v, offset = ValueDecoder.decode_64bit_float(data, offset)
                         v
                       when TYPE_VOID
                         nil
                       when TYPE_ARRAY
                         v, offset = ValueDecoder.decode_array(data, offset)
                         v
                       else
                         raise ArgumentError, "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}\nOffset: #{offset}\nTotal size: #{table_length}\nProcessed data: #{table.inspect}"
                       end
        end

        table
      end # self.decode


      def self.length(data)
        data.unpack(PACK_UINT32).first
      end


      def self.hash_size(value)
        acc = 0
        value.each do |k, v|
          acc += (1 + k.bytesize)
          acc += ValueEncoder.field_value_size(v)
        end

        acc
      end # self.hash_size(value)


      def self.decode_table_key(data, offset)
        key_length = data.slice(offset, 1).unpack(PACK_CHAR).first
        offset += 1
        key = data.slice(offset, key_length)
        offset += key_length

        [key, offset]
      end # self.decode_table_key(data, offset)



    end # Table
  end # Protocol
end # AMQ
