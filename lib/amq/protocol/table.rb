# encoding: binary

module AMQ
  module Protocol
    class Table
      class InvalidTableError < StandardError
        def initialize(key, value)
          super("Invalid table value on key #{key}: #{value.inspect} (#{value.class})")
        end
      end
      
      LC_C  = 'c'.freeze
      LC_Q  = 'q'.freeze
      UC_CN = 'CN'.freeze
      UC_D  = 'D'.freeze
      UC_F  = 'F'.freeze
      UC_I  = 'I'.freeze
      UC_N  = 'N'.freeze
      UC_N2 = 'N2'.freeze
      UC_S  = 'S'.freeze
      UC_T  = 'T'.freeze
      
      TEN = BigDecimal.new('10')

      def self.encode(table)
        buffer = String.new
        table ||= {}
        table.each do |key, value|
          key = key.to_s # it can be a symbol as well
          buffer += key.bytesize.chr + key

          case value
          when String then
            buffer += UC_S
            buffer += [value.bytesize].pack(UC_N)
            buffer += value
          when Integer then
            buffer += UC_I
            buffer += [value].pack(UC_N)
          when TrueClass, FalseClass then
            value = value ? 1 : 0
            buffer += UC_I
            buffer += [value].pack(UC_N)
          when Hash then
            buffer += UC_F # it will work as long as the encoding is ASCII-8BIT
            buffer += self.encode(value)
          when Time then
            # TODO: encode timezone?
            buffer += UC_T
            buffer += [value.to_i].pack(LC_Q).reverse # Don't ask. It works.
          else
            # We don't want to require these libraries.
            if defined?(BigDecimal) && value.is_a?(BigDecimal)
              buffer += UC_D
              if value.exponent < 0
                decimals = -value.exponent
                # p [value.exponent] # normalize
                raw = (value * (decimals ** 10)).to_i
                #pieces.append(struct.pack('>cBI', 'D', decimals, raw)) # byte integer
                buffer += [decimals + 1, raw].pack(UC_CN) # somewhat like floating point
              else
                # per spec, the "decimals" octet is unsigned (!)
                buffer += [0, value.to_i].pack(UC_CN)
              end
            else
              raise InvalidTableError.new(key, value)
            end
          end
        end

        [buffer.bytesize].pack(UC_N) + buffer
      end

      def self.length(data)
        data.unpack(UC_N).first
      end

      def self.decode(data)
        table = Hash.new
        size = data.unpack(UC_N).first
        offset = 4
        while offset < size
          key_length = data.slice(offset, 1).unpack(LC_C).first
          offset += 1
          key = data.slice(offset, key_length)
          offset += key_length
          type = data.slice(offset, 1)
          offset += 1
          case type
          when UC_S then
            length = data.slice(offset, 4).unpack(UC_N).first
            offset += 4
            value = data.slice(offset, length)
            offset += length
          when UC_I then
            value = data.slice(offset, 4).unpack(UC_N).first
            offset += 4
          when UC_D then
            decimals, raw = data.slice(offset, 5).unpack(UC_CN)
            offset += 5
            value = BigDecimal.new(raw.to_s) * (TEN ** -decimals)
          when UC_T then
            # TODO: what is the first unpacked value??? Zone, maybe? It's 0, so it'd make sense.
            timestamp = data.slice(offset, 8).unpack(UC_N2).last
            value = Time.at(timestamp)
            offset += 8
          when UC_F then
            value = self.decode(data.slice(offset, data.bytesize - offset))
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
