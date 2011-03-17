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
    end
  end
end
