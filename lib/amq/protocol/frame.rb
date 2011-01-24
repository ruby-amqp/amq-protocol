# encoding: binary

module AMQ
  module Protocol
    class Frame
      TYPES         = {method: 1, headers: 2, body: 3, heartbeat: 4}
      TYPES_REVERSE = TYPES.inject({}) { |hash, pair| hash.merge!(pair[1] => pair[0]) }
      TYPES_OPTIONS = TYPES.keys
      CHANNEL_RANGE = (0..65535)
      FINAL_OCTET   = "\xCE" # 206

      TYPES.default_proc = lambda { |hash, key| key if (1..4).include?(key) }

      # The channel number is 0 for all frames which are global to the connection and 1-65535 for frames that refer to specific channels.
      def self.encode(type, payload, channel)
        raise FrameTypeError.new(TYPES_OPTIONS) unless TYPES_OPTIONS.include?(type) or (type = TYPES[type])
        raise RuntimeError.new("Channel has to be 0 or an integer in range 1..65535") unless CHANNEL_RANGE.include?(channel)
        raise RuntimeError.new("Payload can't be nil") if payload.nil?
        [TYPES[type], channel, payload.bytesize].pack(PACK_CACHE[:cnN]) + payload + FINAL_OCTET
      end

      class << self
        alias_method :__new__, :new unless method_defined?(:__new__) # because of reloading
      end

      def self.new(original_type, *args)
        type  = TYPES[original_type]
        klass = CLASSES[type]
        raise "Type must be an integer in range 1..4 or #{TYPES_OPTIONS.inspect}, was #{original_type.inspect}" if klass.nil?
        klass.new(*args)
      end

      def self.decode(*)
        raise NotImplementedError.new <<-EOF
You are supposed to redefine this method, because it's dependent on used IO adapter.

This functionality is part of the https://github.com/ruby-amqp/amq-client library.
        EOF
      end

      def self.decode_header(header)
        raise EmptyResponseError.new if header.nil?
        type_id, channel, size = header.unpack(PACK_CACHE[:cnN])
        type = TYPES_REVERSE[type_id]
        raise FrameTypeError.new(TYPES_OPTIONS) unless TYPES_OPTIONS.include?(type)
        [type, channel, size]
      end
    end

    class FrameSubclass < Frame
      # Restore original new
      class << self
        alias_method :new, :__new__
        undef_method :decode if method_defined?(:decode)
      end

      def self.id
        @id
      end

      def self.encode(payload, channel)
        super(@id, payload, channel)
      end

      attr_accessor :channel
      attr_reader :payload
      def initialize(payload, channel)
        @payload, @channel = payload, channel
      end

      def size
        @payload.bytesize
      end

      def encode
        [self.class.id, @channel, self.size].pack(PACK_CACHE[:cnN]) + @payload + FINAL_OCTET
      end
    end

    class MethodFrame < FrameSubclass
      @id = 1

      def method_class
        klass_id, method_id = self.payload.unpack(PACK_CACHE[:n2])
        index = klass_id << 16 | method_id
        AMQ::Protocol::METHODS[index]
      end

      def decode_payload
        self.method_class.decode(@payload[4..-1])
      end
    end

    class HeadersFrame < FrameSubclass
      @id = 2

      attr_reader :body_size, :weight, :klass_id # TODO: lazy-loading, so we don't have to call decode_payload first

      def decode_payload
        @klass_id, @weight = @payload.unpack(PACK_CACHE[:n2])
        @body_size = AMQ::Hacks.unpack_64_big_endian(@payload[4..11]).first # the total size of the content body, that is, the sum of the body sizes for the following content body frames. Zero indicates that there are no content body frames.
        Basic.decode_properties(@payload[11..-1])
      end
    end

    class BodyFrame < FrameSubclass
      @id = 3

      def decode_payload
        @payload
      end
    end

    class HeartbeatFrame < FrameSubclass
      @id = 4
    end

    Frame::CLASSES = {method: MethodFrame, headers: HeadersFrame, body: BodyFrame, heartbeat: HeadersFrame}
    Frame::CLASSES.default_proc = lambda { |hash, key| hash[Frame::TYPES_REVERSE[key]] if (1..4).include?(key) }
  end
end
