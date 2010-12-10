# encoding: ascii-8bit

module AMQP
  module Protocol
    class Table
      class InvalidTableError < StandardError
        def initialize(key, value)
          super("Invalid table value on key #{key}: #{value.inspect} (#{value.class})")
        end
      end

      def self.encode(pieces, table)
        table ||= {}
        length_index = pieces.length
        pieces << nil # placeholder
        tablesize = 0
        table.each do |key, value|
          key = key.to_s # it can be a symbol as well
          # pieces << [key.bytesize.to_s(2)].pack("B*")
          pieces << key.bytesize.chr << key
          tablesize = tablesize + 1 + key.bytesize

          case value
          when String
            pieces << ["S".ord, value.bytesize].pack(">cN")
            pieces << value
            tablesize = tablesize + 5 + value.bytesize
          when Integer
            pieces << ["I".ord, value].pack(">cN")
            tablesize = tablesize + 5
          when TrueClass, FalseClass
            value = value ? 1 : 0
            pieces << ["I".ord, value].pack(">cN")
            tablesize = tablesize + 5
          when Hash
            pieces << "F" # it will work as long as the encoding is ASCII-8BIT
            # tablesize = tablesize + 1 + self.encode(pieces, value).first
            int, _ = self.encode(pieces, value)
            tablesize = tablesize + 1 + int
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
              # tablesize = tablesize + 5
            elsif const_defined?(:DateTime) && value.is_a?(DateTime)
              # TODO
              # pieces << ["T", calendar.timegm(value.utctimetuple())].pack(">cQ")
              # tablesize = tablesize + 9
            else
              raise InvalidTableError.new(key, value)
            end
          end
        end

        pieces[length_index] = [tablesize].pack(">N")
        [tablesize + 4, pieces]
      end

      def self.decode(data, offset)
        # TODO
      end
    end
  end
end
