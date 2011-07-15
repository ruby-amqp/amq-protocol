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
        table = Hash.new
        size = data.unpack(PACK_UINT32).first
        offset = 4
        while offset < size
          key_length = data.slice(offset, 1).unpack(PACK_CHAR).first
          offset += 1
          key = data.slice(offset, key_length)
          offset += key_length
          type = data.slice(offset, 1)
          offset += 1

          case type
          when TYPE_STRING
            length = data.slice(offset, 4).unpack(PACK_UINT32).first
            offset += 4
            value = data.slice(offset, length)
            offset += length
          when TYPE_INTEGER
            value = data.slice(offset, 4).unpack(PACK_UINT32).first
            offset += 4
          when TYPE_DECIMAL
            decimals, raw = data.slice(offset, 5).unpack(PACK_UCHAR_UINT32)
            offset += 5
            value = BigDecimal.new(raw.to_s) * (BigDecimal.new(TEN) ** -decimals)
          when TYPE_TIME
            timestamp = data.slice(offset, 8).unpack(PACK_UINT32_X2).last
            value = Time.at(timestamp)
            offset += 8
          when TYPE_HASH
            length = data.slice(offset, 4).unpack(PACK_UINT32).first
            value = self.decode(data.slice(offset, length + 4))
            offset += 4 + length
          when TYPE_BOOLEAN
            value  = data.slice(offset, 2)
            integer = value.unpack(PACK_CHAR).first # 0 or 1
            value = (integer == 1)
            offset += 1
            value
          when TYPE_SIGNED_8BIT then raise NotImplementedError.new
          when TYPE_SIGNED_16BIT then raise NotImplementedError.new
          when TYPE_SIGNED_64BIT then raise NotImplementedError.new
          when TYPE_32BIT_FLOAT then
            value = data.slice(offset, 4).unpack(PACK_32BIT_FLOAT).first
            offset += 4
          when TYPE_64BIT_FLOAT then
            value = data.slice(offset, 8).unpack(PACK_64BIT_FLOAT).first
            offset += 8
          when TYPE_VOID
            value = nil
          when TYPE_ARRAY
            
          else
            raise ArgumentError, "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}\nOffset: #{offset}\nTotal size: #{size}\nProcessed data: #{table.inspect}"
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
