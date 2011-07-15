# encoding: binary

require "amq/protocol/client"
require "amq/protocol/encoding"
require "amq/protocol/value_encoder"

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
        while offset < table_length
          key_length = data.slice(offset, 1).unpack(PACK_CHAR).first
          offset += 1
          key = data.slice(offset, key_length)
          offset += key_length
          type = data.slice(offset, 1)
          offset += 1

          value = case type
                  when TYPE_STRING
                    length = data.slice(offset, 4).unpack(PACK_UINT32).first
                    offset += 4
                    v = data.slice(offset, length)
                    offset += length

                    v
                  when TYPE_INTEGER
                    v = data.slice(offset, 4).unpack(PACK_UINT32).first
                    offset += 4

                    v
                  when TYPE_DECIMAL
                    decimals, raw = data.slice(offset, 5).unpack(PACK_UCHAR_UINT32)
                    offset += 5
                    BigDecimal.new(raw.to_s) * (BigDecimal.new(TEN) ** -decimals)
                  when TYPE_TIME
                    timestamp = data.slice(offset, 8).unpack(PACK_UINT32_X2).last
                    v = Time.at(timestamp)
                    offset += 8

                    v
                  when TYPE_HASH
                    length = data.slice(offset, 4).unpack(PACK_UINT32).first
                    v = self.decode(data.slice(offset, length + 4))
                    offset += 4 + length

                    v
                  when TYPE_BOOLEAN
                    b  = data.slice(offset, 2)
                    integer = b.unpack(PACK_CHAR).first # 0 or 1
                    offset += 1
                    (integer == 1)
                  when TYPE_SIGNED_8BIT then raise NotImplementedError.new
                  when TYPE_SIGNED_16BIT then raise NotImplementedError.new
                  when TYPE_SIGNED_64BIT then raise NotImplementedError.new
                  when TYPE_32BIT_FLOAT then
                    v = data.slice(offset, 4).unpack(PACK_32BIT_FLOAT).first
                    offset += 4

                    v
                  when TYPE_64BIT_FLOAT then
                    v = data.slice(offset, 8).unpack(PACK_64BIT_FLOAT).first
                    offset += 8

                    v
                  when TYPE_VOID
                    nil
                  when TYPE_ARRAY
                    []
                  else
                    raise ArgumentError, "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}\nOffset: #{offset}\nTotal size: #{table_length}\nProcessed data: #{table.inspect}"
                  end
          table[key] = value
        end

        table
      end # self.decode


      def self.length(data)
        data.unpack(PACK_UINT32).first
      end
    end # Table
  end # Protocol
end # AMQ
