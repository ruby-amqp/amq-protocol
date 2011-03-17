# encoding: utf-8

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    describe Method do
      describe '.split_headers' do
        it 'splits user defined headers into properties and headers' do
          input = {:delivery_mode => 2, :content_type => 'application/octet-stream', :foo => 'bar'}
          properties, headers = Method.split_headers(input)
          properties.should == {:delivery_mode => 2, :content_type => 'application/octet-stream'}
          headers.should == {:foo => 'bar'}
        end
      end
      
      describe '.encode_body' do
        context 'when the body fits in a single frame' do
          it 'encodes a body into a BodyFrame' do
            body_frames = Method.encode_body('Hello world', 1, 131072)
            body_frames.first.payload.should == 'Hello world'
            body_frames.first.channel.should == 1
            body_frames.should have(1).item
          end
        end

        context 'when the body is to big to fit in a single frame' do
          it 'encodes a body into a list of BodyFrames that each fit within the frame size' do
            lipsum = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
            frame_size = 100
            expected_payload_size = 93
            body_frames = Method.encode_body(lipsum, 1, frame_size)
            body_frames.map(&:payload).should == lipsum.split('').each_slice(expected_payload_size).map(&:join)
          end
        end
      end
    end
  
    describe Connection::Start do
      describe '.decode' do
        subject do
          Connection::Start.decode("\x00\t\x00\x00\x00\xFB\tcopyrightS\x00\x00\x00gCopyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.\vinformationS\x00\x00\x005Licensed under the MPL.  See http://www.rabbitmq.com/\bplatformS\x00\x00\x00\nErlang/OTP\aproductS\x00\x00\x00\bRabbitMQ\aversionS\x00\x00\x00\x052.2.0\x00\x00\x00\x0EPLAIN AMQPLAIN\x00\x00\x00\x05en_US")
        end

        its(:version_major) { should == 0 }
        its(:version_minor) { should == 9 }
        its(:server_properties) { should == {'copyright' => 'Copyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.', 'information' => 'Licensed under the MPL.  See http://www.rabbitmq.com/', 'platform' => 'Erlang/OTP', 'product' => 'RabbitMQ', 'version' => '2.2.0'} }
        its(:mechanisms) { should == 'PLAIN AMQPLAIN' }
        its(:locales) { should == 'en_US' }
      end
    end

    describe Connection::StartOk do
      describe '.encode' do
        it 'encodes the parameters into a MethodFrame' do
          client_properties = {:platform => 'Ruby 1.9.2', :product => 'AMQ Client', :information => 'http://github.com/ruby-amqp/amq-client', :version => '0.2.0'}
          mechanism = 'PLAIN'
          response = "\u0000guest\u0000guest"
          locale = 'en_GB'
          method_frame = Connection::StartOk.encode(client_properties, mechanism, response, locale)
          method_frame.payload.should == "\x00\n\x00\v\x00\x00\x00x\bplatformS\x00\x00\x00\nRuby 1.9.2\aproductS\x00\x00\x00\nAMQ Client\vinformationS\x00\x00\x00&http://github.com/ruby-amqp/amq-client\aversionS\x00\x00\x00\x050.2.0\x05PLAIN\x00\x00\x00\f\x00guest\x00guest\x05en_GB"
        end
      end
    end
    
    describe Connection::Tune do
      describe '.decode' do
        subject do
          Connection::Tune.decode("\x00\x00\x00\x02\x00\x00\x00\x00")
        end

        its(:channel_max) { should == 0 }
        its(:frame_max) { should == 131072 }
        its(:heartbeat) { should == 0}
      end
    end

    describe Connection::TuneOk do
      describe '.encode' do
        it 'encodes the parameters into a MethodFrame' do
          channel_max = 0
          frame_max = 65536
          heartbeat = 1
          method_frame = Connection::TuneOk.encode(channel_max, frame_max, heartbeat)
          method_frame.payload.should == "\x00\n\x00\x1F\x00\x00\x00\x01\x00\x00\x00\x01"
        end
      end
    end
  end
end
