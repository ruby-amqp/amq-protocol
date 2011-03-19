# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    class Connection
      describe Start do
        describe '.decode' do
          subject do
            Start.decode("\x00\t\x00\x00\x00\xFB\tcopyrightS\x00\x00\x00gCopyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.\vinformationS\x00\x00\x005Licensed under the MPL.  See http://www.rabbitmq.com/\bplatformS\x00\x00\x00\nErlang/OTP\aproductS\x00\x00\x00\bRabbitMQ\aversionS\x00\x00\x00\x052.2.0\x00\x00\x00\x0EPLAIN AMQPLAIN\x00\x00\x00\x05en_US")
          end

          pending 'offsetting problems in Start.decode' do
            its(:version_major) { should == 0 }
            its(:version_minor) { should == 9 }
            its(:server_properties) { should == {'copyright' => 'Copyright (C) 2007-2010 LShift Ltd., Cohesive Financial Technologies LLC., and Rabbit Technologies Ltd.', 'information' => 'Licensed under the MPL.  See http://www.rabbitmq.com/', 'platform' => 'Erlang/OTP', 'product' => 'RabbitMQ', 'version' => '2.2.0'} }
            its(:mechanisms) { should == 'PLAIN AMQPLAIN' }
            its(:locales) { should == 'en_US' }
          end
        end
      end

      describe StartOk do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            client_properties = {:platform => 'Ruby 1.9.2', :product => 'AMQ Client', :information => 'http://github.com/ruby-amqp/amq-client', :version => '0.2.0'}
            mechanism = 'PLAIN'
            response = "\u0000guest\u0000guest"
            locale = 'en_GB'
            method_frame = StartOk.encode(client_properties, mechanism, response, locale)
            method_frame.payload.should == "\x00\n\x00\v\x00\x00\x00x\bplatformS\x00\x00\x00\nRuby 1.9.2\aproductS\x00\x00\x00\nAMQ Client\vinformationS\x00\x00\x00&http://github.com/ruby-amqp/amq-client\aversionS\x00\x00\x00\x050.2.0\x05PLAIN\x00\x00\x00\f\x00guest\x00guest\x05en_GB"
          end
        end
      end
      
      describe Secure do
        describe '.decode' do
        end
      end
    
      describe SecureOk do
        describe '.encode' do
        end
      end
    
      describe Tune do
        describe '.decode' do
          subject do
            Tune.decode("\x00\x00\x00\x02\x00\x00\x00\x00")
          end

          its(:channel_max) { should == 0 }
          its(:frame_max) { should == 131072 }
          its(:heartbeat) { should == 0}
        end
      end

      describe TuneOk do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel_max = 0
            frame_max = 65536
            heartbeat = 1
            method_frame = TuneOk.encode(channel_max, frame_max, heartbeat)
            method_frame.payload.should == "\x00\n\x00\x1F\x00\x00\x00\x01\x00\x00\x00\x01"
          end
        end
      end
      
      describe Open do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            vhost = '/test'
            method_frame = Open.encode(vhost)
            method_frame.payload.should == "\x00\n\x00(\x05/test\x00\x00"
          end
        end
      end
      
      describe OpenOk do
        describe '.decode' do
          subject do
            OpenOk.decode("\x00")
          end
          
          its(:known_hosts) { should == '' }
        end
      end
      
      describe Close do
        describe '.decode' do
        end
        
        describe '.encode' do
        end
      end
      
      describe CloseOk do
        describe '.encode' do
          it 'encodes a MethodFrame' do
            method_frame = CloseOk.encode
            method_frame.payload.should == "\x00\n\x003"
          end
        end
      end
    end
  end
end
