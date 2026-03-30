# frozen_string_literal: true

module AMQ
  module Protocol
    class Channel
      class Close
        # @return [Boolean] true if the channel was closed due to a consumer delivery acknowledgement timeout
        def delivery_ack_timeout?
          reply_code == 406 && reply_text =~ /delivery acknowledgement on channel \d+ timed out/
        end

        # @return [Boolean] true if the channel was closed due to an unknown delivery tag (e.g. double ack)
        def unknown_delivery_tag?
          reply_code == 406 && reply_text =~ /unknown delivery tag/
        end

        # @return [Boolean] true if the channel was closed because a message exceeded the configured max size
        def message_too_large?
          reply_code == 406 && reply_text =~ /larger than configured max size/
        end
      end
    end
  end
end
