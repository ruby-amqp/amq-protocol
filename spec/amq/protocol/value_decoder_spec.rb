# -*- coding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)

require 'time'
require "amq/protocol/table_value_decoder"

module AMQ
  module Protocol
    describe TableValueDecoder do

      it "is capable of decoding basic arrays TableValueEncoder encodes" do
        input1 = [1, 2, 3]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input1), 1)
        value.size.should == 3
        value.first.should == 1
        value.should == input1



        input2 = ["one", 2, "three"]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        value.size.should == 3
        value.first.should == "one"
        value.should == input2



        input3 = ["one", 2, "three", 4.0, 5000000.0]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input3), 1)
        value.size.should == 5
        value.last.should == 5000000.0
        value.should == input3
      end



      it "is capable of decoding arrays TableValueEncoder encodes" do
        input1 = [{ "one" => 2 }, 3]
        data1  = TableValueEncoder.encode(input1)

        # puts(TableValueEncoder.encode({ "one" => 2 }).inspect)
        # puts(TableValueEncoder.encode(input1).inspect)


        value, offset = described_class.decode_array(data1, 1)
        value.size.should == 2
        value.first.should == Hash["one" => 2]
        value.should == input1



        input2 = ["one", 2, { "three" => { "four" => 5.0 } }]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        value.size.should == 3
        value.last["three"]["four"].should == 5.0
        value.should == input2
      end


    end
  end
end
