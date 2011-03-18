# encoding: utf-8

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
        pending do
          describe '.decode' do
          end
        end
      end

      describe Flow do
        pending do
          describe '.decode' do
          end
        end
        
        pending do
          describe '.encode' do
          end
        end
      end

      describe FlowOk do
        pending do
          describe '.decode' do
          end
        end
      end

      describe Close do
        pending do
          describe '.decode' do
          end
        end
        
        pending do
          describe '.encode' do
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
