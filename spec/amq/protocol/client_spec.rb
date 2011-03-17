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
        it 'encodes a body into a BodyFrame, when it fits in one frame' do
          body_frames = Method.encode_body('Hello world', 1, 131072)
          body_frames.first.payload.should == 'Hello world'
          body_frames.first.channel.should == 1
          body_frames.should have(1).item
        end

        it 'encodes a body into a number of BodyFrames, when it is too big to fit' do
          lipsum = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          body_frames = Method.encode_body(lipsum, 1, 100)
          body_frames.map(&:payload).should == [
            'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut',
            ' labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco la',
            'boris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in volu',
            'ptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat no',
            'n proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          ]
        end
      end
    end
  end
end
