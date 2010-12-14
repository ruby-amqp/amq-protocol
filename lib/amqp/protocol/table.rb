# encoding: binary

module AMQP
  module Protocol
    class Table
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
          buffer += key.bytesize.chr + key

          case value
          when String
            buffer += ["S".ord, value.bytesize].pack(">cN")
            buffer += value
          when Integer
            buffer += ["I".ord, value].pack(">cN")
          when TrueClass, FalseClass
            value = value ? 1 : 0
            buffer += ["I".ord, value].pack(">cN")
          when Hash
            buffer += "F" # it will work as long as the encoding is ASCII-8BIT
            buffer += self.encode(value)
          else
            # We don't want to require these libraries.
            if const_defined?(:BigDecimal) && value.is_a?(BigDecimal)
              # TODO
              # value = value.normalize()
              # if value._exp < 0:
              #     decimals = -value._exp
              #     raw = int(value * (decimal.Decimal(10) ** decimals))
              #     pieces.append(struct.pack('>cBI', 'D', decimals, raw))
              # else:
              #     # per spec, the "decimals" octet is unsigned (!)
              #     pieces.append(struct.pack('>cBI', 'D', 0, int(value)))
            elsif const_defined?(:DateTime) && value.is_a?(DateTime)
              # TODO
              # buffer += ["T", calendar.timegm(value.utctimetuple())].pack(">cQ")
            else
              raise InvalidTableError.new(key, value)
            end
          end
        end

        [buffer.bytesize].pack(">N") + buffer
      end

      def self.decode(data)
        table = Hash.new
        size = data.unpack("N").first
        offset = 4
        while offset < size
          key_length = data[offset].unpack("c").first
          offset += 1
          key = data[offset...(offset += key_length)]
          type = data[offset]
          offset += 1
          case type
          when "S"
            length = data[offset...(offset + 4)].unpack("N").first
            offset += 4
            value = data[offset..(offset + length)]
            offset += length
          when "I"
            value = data[offset...(offset + 4)].unpack("N").first
            offset += 4
          when "D"
            # TODO: decimal
          when "T"
            # TODO: timestamp
          when "F"
            value = self.decode(data[offset..-1])
          else
            raise
          end
          table[key] = value
        end

        table
      end
    end
  end
end
