# encoding: binary

require "amq/protocol/client"
require "amq/protocol/encoding"
require "amq/protocol/table"

module AMQ
  module Protocol

    class ValueEncoder

      #
      # Behaviors
      #

      include Encoding

      #
      # API
      #

      def self.encode(value)
        accumulator = String.new

        case value
        when String then
          accumulator << TYPE_STRING
          accumulator << [value.bytesize].pack(PACK_UINT32)
          accumulator << value
        when Symbol then
          v = value.to_s
          accumulator << TYPE_STRING
          accumulator << [v.bytesize].pack(PACK_UINT32)
          accumulator << v
        when Integer then
          accumulator << TYPE_INTEGER
          accumulator << [value].pack(PACK_UINT32)
        when Float then
          accumulator << TYPE_64BIT_FLOAT
          accumulator << [value].pack(PACK_64BIT_FLOAT)
        when true, false then
          accumulator << TYPE_BOOLEAN
          accumulator << (value ? BOOLEAN_TRUE : BOOLEAN_FALSE)
        when Time then
          accumulator << TYPE_TIME
          accumulator << [value.to_i].pack(PACK_INT64).reverse # FIXME: there has to be a more efficient way
        when nil then
          accumulator << TYPE_VOID
        when Array then
          accumulator << TYPE_ARRAY
          accumulator << value.length

          value.each { |v| accumulator << self.encode(v) }
        when Hash then
          accumulator << AMQ::Protocol::Table.encode(value)
        else
          # We don't want to require these libraries.
          if defined?(BigDecimal) && value.is_a?(BigDecimal)
            accumulator << TYPE_DECIMAL
            if value.exponent < 0
              decimals = -value.exponent
              raw = (value * (decimals ** 10)).to_i
              accumulator << [decimals + 1, raw].pack(PACK_UCHAR_UINT32) # somewhat like floating point
            else
              # per spec, the "decimals" octet is unsigned (!)
              accumulator << [0, value.to_i].pack(PACK_UCHAR_UINT32)
            end
          else
            raise ArgumentError.new("Unsupported value #{value.inspect} of type #{value.class.name}")
          end # if
        end # case

        accumulator
      end # self.encode(value)

    end # ValueEncoder

  end # Protocol
end # AMQ
