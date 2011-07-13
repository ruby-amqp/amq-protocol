# encoding: binary

require "amq/protocol/client"

# We will need to introduce concept of mappings, because
# AMQP 0.9, 0.9.1 and RabbitMQ uses different letters for entities
# http://dev.rabbitmq.com/wiki/Amqp091Errata#section_3
module AMQ
  module Protocol
    class Table
      class InvalidTableError < StandardError
        def initialize(key, value)
          super("Invalid table value on key #{key}: #{value.inspect} (#{value.class})")
        end
      end

      TYPE_STRING = 'S'.freeze
      TYPE_INTEGER = 'I'.freeze
      TYPE_HASH = 'F'.freeze
      TYPE_TIME = 'T'.freeze
      TYPE_DECIMAL = 'D'.freeze
      TYPE_BOOLEAN = 't'.freeze
      TYPE_SIGNED_8BIT = 'b'.freeze
      TYPE_SIGNED_16BIT = 's'.freeze
      TYPE_SIGNED_64BIT = 'l'.freeze
      TYPE_32BIT_FLOAT = 'f'.freeze
      TYPE_64BIT_FLOAT = 'd'.freeze
      TYPE_VOID = 'V'.freeze
      TYPE_BYTE_ARRAY = 'x'.freeze
      TEN = '10'.freeze

      BOOLEAN_TRUE  = "\x01".freeze
      BOOLEAN_FALSE = "\x00".freeze


      def self.encode(table)
        buffer = String.new
        table ||= {}
        table.each do |key, value|
          key = key.to_s # it can be a symbol as well
          buffer << key.bytesize.chr + key

          case value
          when String then
            buffer << TYPE_STRING
            buffer << [value.bytesize].pack(PACK_UINT32)
            buffer << value
          when Integer then
            buffer << TYPE_INTEGER
            buffer << [value].pack(PACK_UINT32)
          when Float then
            buffer << TYPE_64BIT_FLOAT
            buffer << [value].pack(PACK_64BIT_FLOAT)
          when true, false then
            buffer << TYPE_BOOLEAN
            buffer << (value ? BOOLEAN_TRUE : BOOLEAN_FALSE)
          when Hash then
            buffer << TYPE_HASH # TODO: encoding support
            buffer << self.encode(value)
          when Time then
            buffer << TYPE_TIME
            buffer << [value.to_i].pack(PACK_INT64).reverse # FIXME: there has to be a more efficient way
          else
            # We don't want to require these libraries.
            if defined?(BigDecimal) && value.is_a?(BigDecimal)
              buffer << TYPE_DECIMAL
              if value.exponent < 0
                decimals = -value.exponent
                # p [value.exponent] # normalize
                raw = (value * (decimals ** 10)).to_i
                #pieces.append(struct.pack('>cBI', 'D', decimals, raw)) # byte integer
                buffer << [decimals + 1, raw].pack(PACK_UCHAR_UINT32) # somewhat like floating point
              else
                # per spec, the "decimals" octet is unsigned (!)
                buffer << [0, value.to_i].pack(PACK_UCHAR_UINT32)
              end
            else
              raise InvalidTableError.new(key, value)
            end
          end
        end

        [buffer.bytesize].pack(PACK_UINT32) + buffer
      end

      def self.length(data)
        data.unpack(PACK_UINT32).first
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
          when TYPE_BYTE_ARRAY
          else
            raise "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}\nOffset: #{offset}\nTotal size: #{size}\nProcessed data: #{table.inspect}"
          end
          table[key] = value
        end

        table
      end
    end
  end
end
