# encoding: utf-8

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
          pieces << [key.to_s.length].pack("B")
          pieces << key
          tablesize = tablesize + 1 + key.length

          case value
          when String
            pieces << ["S", value.length].pack(">cI")
            pieces << value
            tablesize = tablesize + 5 + value.length
          when Integer
            pieces << ["I", value].pack(">cI")
            tablesize = tablesize + 5
          when Hash
            pieces << ["F"].pack(">c")
            tablesize = tablesize + 1 + self.encode(pieces, value)
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

        pieces[length_index] = [tablesize].pack(">I")
        [tablesize + 4, pieces]
      end

      def self.decode(data, offset)
        # TODO
      end
    end
  end
end
