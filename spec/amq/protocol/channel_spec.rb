# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    class Channel
      describe Open do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            out_of_band = ''
            method_frame = Open.encode(channel, out_of_band)
            method_frame.payload.should == "\x00\x14\x00\n\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe OpenOk do
        describe '.decode' do
          subject do
            OpenOk.decode("\x00\x00\x00\x03foo")
          end
          
          its(:channel_id) { should == 'foo' }
        end
      end

      describe Flow do
        describe '.decode' do
          subject do
            Flow.decode("\x01")
          end
          
          its(:active) { should be_true }
        end

        describe '.encode' do
          it 'encodes the parameters as a MethodFrame' do
            channel = 1
            active = true
            method_frame = Flow.encode(channel, active)
            method_frame.payload.should == "\x00\x14\x00\x14\x01"
            method_frame.channel.should == 1
          end
        end
      end

      describe FlowOk do
        describe '.decode' do
          subject do
            FlowOk.decode("\x00")
          end
          
          its(:active) { should be_false }
        end
        
        describe '.encode' do
          it 'encodes the parameters as a MethodFrame' do
            channel = 1
            active = true
            method_frame = FlowOk.encode(channel, active)
            method_frame.payload.should == "\x00\x14\x00\x15\x01"
            method_frame.channel.should == 1
          end
        end
      end

      describe Close do
        describe '.decode' do
          context 'with code 200' do
            subject do
              Close.decode("\x00\xc8\x07KTHXBAI\x00\x05\x00\x06")
            end
          
            its(:reply_code) { should == 200 }
            its(:reply_text) { should == 'KTHXBAI' }
            its(:class_id) { should == 5 }
            its(:method_id) { should == 6 }
          end
          
          context 'with an error code' do
            it 'raises the corresponding error' do
              expect { Close.decode("\x01\x38\x08NO_ROUTE\x00\x00") }.to raise_error(NoRoute, 'NO_ROUTE')
            end
          end
        end
        
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            reply_code = 540
            reply_text = 'NOT_IMPLEMENTED'
            class_id = 0
            method_id = 0
            method_frame = Close.encode(channel, reply_code, reply_text, class_id, method_id)
            method_frame.payload.should == "\x00\x14\x00(\x02\x1c\x0fNOT_IMPLEMENTED\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe CloseOk do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            method_frame = CloseOk.encode(1)
            method_frame.payload.should == "\x00\x14\x00\x29"
            method_frame.channel.should == 1
          end
        end
      end
    end
  end
end
