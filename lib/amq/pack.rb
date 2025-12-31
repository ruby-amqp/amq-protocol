# encoding: binary
# frozen_string_literal: true

module AMQ
  # Implements pack to/unpack from 64bit string in network byte order.
  # Uses native Ruby pack directives with explicit endianness (Ruby 1.9.3+).
  module Pack
    # Pack format strings - frozen for performance
    UINT64_BE = 'Q>'.freeze  # 64-bit unsigned, big-endian
    INT64_BE  = 'q>'.freeze  # 64-bit signed, big-endian
    INT16_BE  = 's>'.freeze  # 16-bit signed, big-endian
    UINT16_BE = 'n'.freeze   # 16-bit unsigned, big-endian (network order)

    # Packs a 64-bit unsigned integer to big-endian binary string.
    # @param long_long [Integer] The value to pack
    # @return [String] 8-byte binary string in big-endian order
    def self.pack_uint64_big_endian(long_long)
      [long_long].pack(UINT64_BE)
    end

    # Unpacks a big-endian binary string to a 64-bit unsigned integer.
    # @param data [String] 8-byte binary string in big-endian order
    # @return [Array<Integer>] Single-element array containing the unpacked value
    def self.unpack_uint64_big_endian(data)
      data.unpack(UINT64_BE)
    end

    # Packs a 16-bit signed integer to big-endian binary string.
    # @param short [Integer] The value to pack
    # @return [String] 2-byte binary string in big-endian order
    def self.pack_int16_big_endian(short)
      [short].pack(INT16_BE)
    end

    # Unpacks a big-endian binary string to a 16-bit signed integer.
    # @param data [String] 2-byte binary string in big-endian order
    # @return [Array<Integer>] Single-element array containing the unpacked value
    def self.unpack_int16_big_endian(data)
      data.unpack(INT16_BE)
    end
  end

  # Backwards compatibility alias
  Hacks = Pack
end
