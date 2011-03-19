# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    describe Basic do
      describe '.encode_content_type' do
      end

      describe '.encode_content_encoding' do
      end

      describe '.encode_headers' do
      end

      describe '.encode_delivery_mode' do
      end

      describe '.encode_priority' do
      end

      describe '.encode_correlation_id' do
      end

      describe '.encode_reply_to' do
      end

      describe '.encode_expiration' do
      end

      describe '.encode_message_id' do
      end

      describe '.encode_timestamp' do
      end

      describe '.encode_type' do
      end

      describe '.encode_user_id' do
      end

      describe '.encode_app_id' do
      end

      describe '.encode_cluster_id' do
      end

      describe '.encode_properties' do
      end

      describe '.decode_content_type' do
      end

      describe '.decode_content_encoding' do
      end

      describe '.decode_headers' do
      end

      describe '.decode_delivery_mode' do
      end

      describe '.decode_priority' do
      end

      describe '.decode_correlation_id' do
      end

      describe '.decode_reply_to' do
      end

      describe '.decode_expiration' do
      end

      describe '.decode_message_id' do
      end

      describe '.decode_timestamp' do
      end

      describe '.decode_type' do
      end

      describe '.decode_user_id' do
      end

      describe '.decode_app_id' do
      end

      describe '.decode_cluster_id' do
      end

      describe '.decode_content_type' do
      end

      describe '.decode_content_encoding' do
      end

      describe '.decode_headers' do
      end

      describe '.decode_delivery_mode' do
      end

      describe '.decode_priority' do
      end

      describe '.decode_correlation_id' do
      end

      describe '.decode_reply_to' do
      end

      describe '.decode_expiration' do
      end

      describe '.decode_message_id' do
      end

      describe '.decode_timestamp' do
      end

      describe '.decode_type' do
      end

      describe '.decode_user_id' do
      end

      describe '.decode_app_id' do
      end

      describe '.decode_cluster_id' do
      end

      describe '.decode_properties' do
      end
    end
    
    class Basic
      describe Qos do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            prefetch_size = 3
            prefetch_count = 5
            global = false
            method_frame = Qos.encode(channel, prefetch_size, prefetch_count, global)
            method_frame.payload.should == "\x00<\x00\n\x00\x00\x00\x03\x00\x05\x00"
            method_frame.channel.should == 1
          end
        end
      end

      # describe QosOk do
      #   describe '.decode' do
      #   end
      # end

      describe Consume do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'foo'
            consumer_tag = 'me'
            no_local = false
            no_ack = false
            exclusive = true
            nowait = false
            arguments = nil
            method_frame = Consume.encode(channel, queue, consumer_tag, no_local, no_ack, exclusive, nowait, arguments)
            method_frame.payload.should == "\x00<\x00\x14\x00\x00\x03foo\x02me\x04\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe ConsumeOk do
        describe '.decode' do
          subject do
            ConsumeOk.decode("\x03foo")
          end
          
          its(:consumer_tag) { should == 'foo' }
        end
      end

      describe Cancel do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            consumer_tag = 'foo'
            nowait = true
            method_frame = Cancel.encode(channel, consumer_tag, nowait)
            method_frame.payload.should == "\x00<\x00\x1E\x03foo\x01"
            method_frame.channel.should == 1
          end
        end
      end

      describe CancelOk do
        describe '.decode' do
          subject do
            CancelOk.decode("\x03foo")
          end
          
          its(:consumer_tag) { should == 'foo' }
        end
      end

      describe Publish do
        describe '.encode' do
          it 'encodes the parameters into a list of MethodFrames' do
            channel = 1
            payload = 'Hello World!'
            user_headers = {:priority => 0, :content_type => 'application/octet-stream'}
            exchange = 'foo'
            routing_key = 'xyz'
            mandatory = false
            immediate = true
            frame_size = 512
            method_frames = Publish.encode(channel, payload, user_headers, exchange, routing_key, mandatory, immediate, frame_size)
            method_frames[0].payload.should == "\x00<\x00(\x00\x00\x03foo\x03xyz\x02"
            method_frames[1].payload.should == "\x00<\x00\x00\x00\x00\x00\x00\x00\x00\x00\f\x88\x00\x18application/octet-stream\x00"
            method_frames[2].payload.should == "Hello World!"
            method_frames[0].channel.should == 1
            method_frames[1].channel.should == 1
            method_frames[2].channel.should == 1
            method_frames.should have(3).items
          end
        end
      end

      describe Return do
        describe '.decode' do
          subject do
            Return.decode("\x019\fNO_CONSUMERS\namq.fanout\x00")
          end
          
          its(:reply_code) { should == 313 }
          its(:reply_text) { should == 'NO_CONSUMERS' }
          its(:exchange) { should == 'amq.fanout' }
          its(:routing_key) { should == '' }
        end
      end

      describe Deliver do
        describe '.decode' do
          subject do
            Deliver.decode("\e-1300560114000-445586772970\x00\x00\x00\x00\x00\x00\x00c\x00\namq.fanout\x00")
          end
          
          its(:consumer_tag) { should == '-1300560114000-445586772970' }
          its(:delivery_tag) { should == 99 }
          its(:redelivered) { should == false }
          its(:exchange) { should == 'amq.fanout' }
          its(:routing_key) { should == '' }
        end
      end
      
      describe Get do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'foo'
            no_ack = true
            method_frame = Get.encode(channel, queue, no_ack)
            method_frame.payload.should == "\x00\x3c\x00\x46\x00\x00\x03foo\x01"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe GetOk do
        describe '.decode' do
          subject do
            GetOk.decode("\x00\x00\x00\x00\x00\x00\x00\x06\x00\namq.fanout\x00\x00\x00\x00^")
          end
          
          its(:delivery_tag) { should == 6 }
          its(:redelivered) { should == false }
          its(:exchange) { should == 'amq.fanout' }
          its(:routing_key) { should == '' }
          its(:message_count) { should == 94 }
        end
      end
      
      describe GetEmpty do
        describe '.decode' do
          subject do
            GetEmpty.decode("\x03foo")
          end
          
          its(:cluster_id) { should == 'foo' }
        end
      end

      describe Ack do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            delivery_tag = 'foot'
            multiple = false
            method_frame = Ack.encode(channel, 6, multiple)
            method_frame.payload.should == "\x00<\x00P\x00\x00\x00\x00\x00\x00\x00\x06\x00"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe Reject do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            delivery_tag = 8
            requeue = true
            method_frame = Reject.encode(channel, delivery_tag, requeue)
            method_frame.payload.should == "\x00<\x00Z\x00\x00\x00\x00\x00\x00\x00\x08\x01"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe RecoverAsync do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            requeue = true
            method_frame = RecoverAsync.encode(channel, requeue)
            method_frame.payload.should == "\x00<\x00d\x01"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe Recover do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            requeue = true
            method_frame = Recover.encode(channel, requeue)
            method_frame.payload.should == "\x00<\x00n\x01"
            method_frame.channel.should == 1
          end
        end
      end

      # describe RecoverOk do
      #   describe '.decode' do
      #   end
      # end
      
      describe Nack do
        describe '.decode' do
          subject do
            Nack.decode("\x00\x00\x00\x00\x00\x00\x00\x09\x03")
          end
          
          pending '"requeue" is not defined' do
            its(:delivery_tag) { should == 9 }
            its(:multiple) { should == true }
            its(:requeue) { should == true }
          end
        end
        
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            delivery_tag = 10
            multiple = false
            requeue = true
            method_frame = Nack.encode(channel, delivery_tag, multiple, requeue)
            method_frame.payload.should == "\x00<\x00x\x00\x00\x00\x00\x00\x00\x00\x0a\x02"
            method_frame.channel.should == 1
          end
        end
      end
    end
  end
end