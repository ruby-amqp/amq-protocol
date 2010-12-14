# encoding: binary

module AMQP
  module Protocol
    # Example:
    # Frame.encode(:method, 0, Connection::TuneOk.encode(0, 131072, 0))
    class Frame
      TYPES         = {method: 1, header: 2, body: 3, heartbeat: 4}
      TYPES_REVERSE = TYPES.inject({}) { |hash, pair| hash[pair[1]] = pair[0]; hash }
      TYPES_OPTIONS = TYPES.keys
      CHANNEL_RANGE = (0..65535)
      FINAL_OCTET   = "\xCE" # 206

      # The channel number is 0 for all frames which are global to the connection and 1-65535 for frames that refer to specific channels.
      def self.encode(type, channel, payload)
        raise RuntimeError.new("Must be one of #{TYPES_OPTIONS.inspect}") unless TYPES_OPTIONS.include?(type)
        raise RuntimeError.new("Channel has to be 0 or an integer in range 1..65535") unless CHANNEL_RANGE.include?(channel)
        raise RuntimeError.new("Payload can't be nil") if payload.nil?
        [TYPES[type], channel, payload.bytesize].pack("cnN") + payload + FINAL_OCTET
      end

      def self.decode(readable)
        header = readable.read(7)
        type_id, channel, size = header.unpack("cnN")
        type = TYPES_REVERSE[type_id]
        data = readable.read(size + 1)
        payload, frame_end = data[0..-2], data[-1]
        raise RuntimeError.new("Frame doesn't end with #{FINAL_OCTET} as it must, which means the size is miscalculated.") unless frame_end == FINAL_OCTET
        # raise RuntimeError.new("invalid size: is #{payload.bytesize}, expected #{size}") if @payload.bytesize != size # We obviously can't test that, because we used read(size), so it's pointless.
        self.new(type, channel, size, payload)
      end

      attr_reader :type, :channel, :size, :payload
      def initialize(type, channel, size, payload)
        @type, @channel, @size, @payload = type, channel, size, payload
      end

      def first_method
        klass_id, method_id = self.payload.unpack("n2")
        index = klass_id << 16 | method_id
        AMQP::Protocol::METHODS[index]
      end

      def decode_first_method
        self.first_method.decode(self.payload[4..-1])
      end

      def decode
        # TODO
      end
    end
  end
end
