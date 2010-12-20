# encoding: binary

module AMQ
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
            buffer += "S"
            buffer += [value.bytesize].pack("N")
            buffer += value
          when Integer
            buffer += "I"
            buffer += [value].pack("N")
          when TrueClass, FalseClass
            value = value ? 1 : 0
            buffer += "I"
            buffer += [value].pack("N")
          when Hash
            buffer += "F" # it will work as long as the encoding is ASCII-8BIT
            buffer += self.encode(value)
          when Time
            # TODO: encode timezone?
            buffer += "T"
            buffer += [value.to_i].pack("q").reverse # Don't ask. It works.
          else
            # We don't want to require these libraries.
            if const_defined?(:BigDecimal) && value.is_a?(BigDecimal)
              buffer += "D"
              if value.exponent < 0
                decimals = -value.exponent
                p [value.exponent] # normalize
                raw = (value * (decimals ** 10)).to_i
                #pieces.append(struct.pack('>cBI', 'D', decimals, raw)) # byte integer
                buffer += [decimals + 1, raw].pack("CN") # somewhat like floating point
              else
                # per spec, the "decimals" octet is unsigned (!)
                buffer += [0, value.to_i].pack("CN")
              end
            else
              raise InvalidTableError.new(key, value)
            end
          end
        end

        [buffer.bytesize].pack("N") + buffer
      end

      def self.length(data)
        data.unpack("N").first
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
            decimals, raw = data[offset..(offset + 5)].unpack("CN")
            offset += 5
            value = BigDecimal.new(raw.to_s) * (BigDecimal.new("10") ** -decimals)
          when "T"
            # TODO: what is the first unpacked value??? Zone, maybe? It's 0, so it'd make sense.
            timestamp = data[offset..(offset + 8)].unpack("N2").last
            value = Time.at(timestamp)
            offset += 8
          when "F"
            value = self.decode(data[offset..-1])
          else
            raise "Not a valid type: #{type.inspect}\nData: #{data.inspect}\nUnprocessed data: #{data[offset..-1].inspect}"
          end
          table[key] = value
        end

        table
      end
    end
  end
end
