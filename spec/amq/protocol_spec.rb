# encoding: utf-8

require "spec_helper"

describe AMQ::Protocol do
  it "should have PROTOCOL_VERSION constant" do
    AMQ::Protocol::PROTOCOL_VERSION.should match(/^\d+\.\d+\.\d$/)
  end

  it "should have DEFAULT_PORT constant" do
    AMQ::Protocol::DEFAULT_PORT.should be_kind_of(Integer)
  end

  it "should have PREAMBLE constant" do
    AMQ::Protocol::PREAMBLE.should be_kind_of(String)
  end

  describe AMQ::Protocol::Error do
    it "should be an exception class" do
      AMQ::Protocol::Error.should < Exception
    end
  end

  describe AMQ::Protocol::Connection do
    it "should be a subclass of Class" do
      AMQ::Protocol::Connection.superclass.should == AMQ::Protocol::Class
    end

    it "should have name equal to connection" do
      AMQ::Protocol::Connection.name.should eql("connection")
    end

    it "should have method id equal to 10" do
      AMQ::Protocol::Connection.method_id.should == 10
    end

    describe AMQ::Protocol::Connection::Start do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::Start.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.start" do
        AMQ::Protocol::Connection::Start.name.should eql("connection.start")
      end

      it "should have method id equal to 10" do
        AMQ::Protocol::Connection::Start.method_id.should == 10
      end
    end

    describe AMQ::Protocol::Connection::StartOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::StartOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.start-ok" do
        AMQ::Protocol::Connection::StartOk.name.should eql("connection.start-ok")
      end

      it "has method id equal to 11" do
        AMQ::Protocol::Connection::StartOk.method_id.should == 11
      end
    end

    describe AMQ::Protocol::Connection::Secure do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::Secure.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.secure" do
        AMQ::Protocol::Connection::Secure.name.should eql("connection.secure")
      end

      it "has method id equal to 20" do
        AMQ::Protocol::Connection::Secure.method_id.should == 20
      end
    end

    describe AMQ::Protocol::Connection::SecureOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::SecureOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.secure-ok" do
        AMQ::Protocol::Connection::SecureOk.name.should eql("connection.secure-ok")
      end

      it "has method id equal to 21" do
        AMQ::Protocol::Connection::SecureOk.method_id.should == 21
      end
    end

    describe AMQ::Protocol::Connection::Tune do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::Tune.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.tune" do
        AMQ::Protocol::Connection::Tune.name.should eql("connection.tune")
      end

      it "has method id equal to 30" do
        AMQ::Protocol::Connection::Tune.method_id.should == 30
      end
    end

    describe AMQ::Protocol::Connection::TuneOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::TuneOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.tune-ok" do
        AMQ::Protocol::Connection::TuneOk.name.should eql("connection.tune-ok")
      end

      it "has method id equal to 31" do
        AMQ::Protocol::Connection::TuneOk.method_id.should == 31
      end

      describe ".encode" do
        it do
          frame = AMQ::Protocol::Connection::TuneOk.encode(0, 131072, 0)
          frame.payload.should eql("\x00\n\x00\x1F\x00\x00\x00\x02\x00\x00\x00\x00")
        end
      end
    end

    describe AMQ::Protocol::Connection::Open do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::Open.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.open" do
        AMQ::Protocol::Connection::Open.name.should eql("connection.open")
      end

      it "has method id equal to 40" do
        AMQ::Protocol::Connection::Open.method_id.should == 40
      end
    end

    describe AMQ::Protocol::Connection::OpenOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::OpenOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.open-ok" do
        AMQ::Protocol::Connection::OpenOk.name.should eql("connection.open-ok")
      end

      it "has method id equal to 41" do
        AMQ::Protocol::Connection::OpenOk.method_id.should == 41
      end
    end

    describe AMQ::Protocol::Connection::Close do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::Close.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.close" do
        AMQ::Protocol::Connection::Close.name.should eql("connection.close")
      end

      it "has method id equal to 50" do
        AMQ::Protocol::Connection::Close.method_id.should == 50
      end
    end

    describe AMQ::Protocol::Connection::CloseOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Connection::CloseOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to connection.close-ok" do
        AMQ::Protocol::Connection::CloseOk.name.should eql("connection.close-ok")
      end

      it "has method id equal to 51" do
        AMQ::Protocol::Connection::CloseOk.method_id.should == 51
      end
    end
  end

  describe AMQ::Protocol::Channel do
    it "should be a subclass of Class" do
      AMQ::Protocol::Channel.superclass.should == AMQ::Protocol::Class
    end

    it "should have name equal to channel" do
      AMQ::Protocol::Channel.name.should eql("channel")
    end

    it "has method id equal to 20" do
      AMQ::Protocol::Channel.method_id.should == 20
    end

    describe AMQ::Protocol::Channel::Open do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::Open.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.open" do
        AMQ::Protocol::Channel::Open.name.should eql("channel.open")
      end

      it "has method id equal to 10" do
        AMQ::Protocol::Channel::Open.method_id.should == 10
      end
    end

    describe AMQ::Protocol::Channel::OpenOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::OpenOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.open-ok" do
        AMQ::Protocol::Channel::OpenOk.name.should eql("channel.open-ok")
      end

      it "has method id equal to 11" do
        AMQ::Protocol::Channel::OpenOk.method_id.should == 11
      end
    end

    describe AMQ::Protocol::Channel::Flow do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::Flow.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.flow" do
        AMQ::Protocol::Channel::Flow.name.should eql("channel.flow")
      end

      it "has method id equal to 20" do
        AMQ::Protocol::Channel::Flow.method_id.should == 20
      end
    end

    describe AMQ::Protocol::Channel::FlowOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::FlowOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.flow-ok" do
        AMQ::Protocol::Channel::FlowOk.name.should eql("channel.flow-ok")
      end

      it "has method id equal to 21" do
        AMQ::Protocol::Channel::FlowOk.method_id.should == 21
      end
    end

    describe AMQ::Protocol::Channel::Close do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::Close.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.close" do
        AMQ::Protocol::Channel::Close.name.should eql("channel.close")
      end

      it "has method id equal to 40" do
        AMQ::Protocol::Channel::Close.method_id.should == 40
      end
    end

    describe AMQ::Protocol::Channel::CloseOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Channel::CloseOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to channel.close-ok" do
        AMQ::Protocol::Channel::CloseOk.name.should eql("channel.close-ok")
      end

      it "has method id equal to 41" do
        AMQ::Protocol::Channel::CloseOk.method_id.should == 41
      end
    end
  end

  describe AMQ::Protocol::Exchange do
    it "should be a subclass of Class" do
      AMQ::Protocol::Exchange.superclass.should == AMQ::Protocol::Class
    end

    it "should have name equal to exchange" do
      AMQ::Protocol::Exchange.name.should eql("exchange")
    end

    it "has method id equal to 40" do
      AMQ::Protocol::Exchange.method_id.should == 40
    end

    describe AMQ::Protocol::Exchange::Declare do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::Declare.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.declare" do
        AMQ::Protocol::Exchange::Declare.name.should eql("exchange.declare")
      end

      it "has method id equal to 10" do
        AMQ::Protocol::Exchange::Declare.method_id.should == 10
      end
    end

    describe AMQ::Protocol::Exchange::DeclareOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::DeclareOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.declare-ok" do
        AMQ::Protocol::Exchange::DeclareOk.name.should eql("exchange.declare-ok")
      end

      it "has method id equal to 11" do
        AMQ::Protocol::Exchange::DeclareOk.method_id.should == 11
      end
    end

    describe AMQ::Protocol::Exchange::Delete do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::Delete.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.delete" do
        AMQ::Protocol::Exchange::Delete.name.should eql("exchange.delete")
      end

      it "has method id equal to 20" do
        AMQ::Protocol::Exchange::Delete.method_id.should == 20
      end
    end

    describe AMQ::Protocol::Exchange::DeleteOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::DeleteOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.delete-ok" do
        AMQ::Protocol::Exchange::DeleteOk.name.should eql("exchange.delete-ok")
      end

      it "has method id equal to 21" do
        AMQ::Protocol::Exchange::DeleteOk.method_id.should == 21
      end
    end

    describe AMQ::Protocol::Exchange::Bind do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::Bind.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.bind" do
        AMQ::Protocol::Exchange::Bind.name.should eql("exchange.bind")
      end

      it "has method id equal to 30" do
        AMQ::Protocol::Exchange::Bind.method_id.should == 30
      end
    end

    describe AMQ::Protocol::Exchange::BindOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::BindOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.bind-ok" do
        AMQ::Protocol::Exchange::BindOk.name.should eql("exchange.bind-ok")
      end

      it "has method id equal to 31" do
        AMQ::Protocol::Exchange::BindOk.method_id.should == 31
      end
    end

    describe AMQ::Protocol::Exchange::Unbind do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::Unbind.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.unbind" do
        AMQ::Protocol::Exchange::Unbind.name.should eql("exchange.unbind")
      end

      it "has method id equal to 40" do
        AMQ::Protocol::Exchange::Unbind.method_id.should == 40
      end
    end

    describe AMQ::Protocol::Exchange::UnbindOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Exchange::UnbindOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to exchange.unbind-ok" do
        AMQ::Protocol::Exchange::UnbindOk.name.should eql("exchange.unbind-ok")
      end

      it "has method id equal to 51" do
        AMQ::Protocol::Exchange::UnbindOk.method_id.should == 51
      end
    end
  end

  describe AMQ::Protocol::Queue do
    it "should be a subclass of Class" do
      AMQ::Protocol::Queue.superclass.should == AMQ::Protocol::Class
    end

    it "should have name equal to queue" do
      AMQ::Protocol::Queue.name.should eql("queue")
    end

    it "has method id equal to 50" do
      AMQ::Protocol::Queue.method_id.should == 50
    end

    describe AMQ::Protocol::Queue::Declare do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::Declare.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.declare" do
        AMQ::Protocol::Queue::Declare.name.should eql("queue.declare")
      end

      it "has method id equal to 10" do
        AMQ::Protocol::Queue::Declare.method_id.should == 10
      end
    end

    describe AMQ::Protocol::Queue::DeclareOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::DeclareOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.declare-ok" do
        AMQ::Protocol::Queue::DeclareOk.name.should eql("queue.declare-ok")
      end

      it "has method id equal to 11" do
        AMQ::Protocol::Queue::DeclareOk.method_id.should == 11
      end
    end

    describe AMQ::Protocol::Queue::Bind do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::Bind.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.bind" do
        AMQ::Protocol::Queue::Bind.name.should eql("queue.bind")
      end

      it "has method id equal to 20" do
        AMQ::Protocol::Queue::Bind.method_id.should == 20
      end
    end

    describe AMQ::Protocol::Queue::BindOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::BindOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.bind-ok" do
        AMQ::Protocol::Queue::BindOk.name.should eql("queue.bind-ok")
      end

      it "has method id equal to 21" do
        AMQ::Protocol::Queue::BindOk.method_id.should == 21
      end
    end

    describe AMQ::Protocol::Queue::Purge do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::Purge.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.purge" do
        AMQ::Protocol::Queue::Purge.name.should eql("queue.purge")
      end

      it "has method id equal to 30" do
        AMQ::Protocol::Queue::Purge.method_id.should == 30
      end
    end

    describe AMQ::Protocol::Queue::PurgeOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::PurgeOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.purge-ok" do
        AMQ::Protocol::Queue::PurgeOk.name.should eql("queue.purge-ok")
      end

      it "has method id equal to 31" do
        AMQ::Protocol::Queue::PurgeOk.method_id.should == 31
      end
    end

    describe AMQ::Protocol::Queue::Delete do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::Delete.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.delete" do
        AMQ::Protocol::Queue::Delete.name.should eql("queue.delete")
      end

      it "has method id equal to 40" do
        AMQ::Protocol::Queue::Delete.method_id.should == 40
      end
    end

    describe AMQ::Protocol::Queue::DeleteOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::DeleteOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.delete-ok" do
        AMQ::Protocol::Queue::DeleteOk.name.should eql("queue.delete-ok")
      end

      it "has method id equal to 41" do
        AMQ::Protocol::Queue::DeleteOk.method_id.should == 41
      end
    end

    describe AMQ::Protocol::Queue::Unbind do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::Unbind.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.unbind" do
        AMQ::Protocol::Queue::Unbind.name.should eql("queue.unbind")
      end

      it "has method id equal to 50" do
        AMQ::Protocol::Queue::Unbind.method_id.should == 50
      end
    end

    describe AMQ::Protocol::Queue::UnbindOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Queue::UnbindOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to queue.unbind-ok" do
        AMQ::Protocol::Queue::UnbindOk.name.should eql("queue.unbind-ok")
      end

      it "has method id equal to 51" do
        AMQ::Protocol::Queue::UnbindOk.method_id.should == 51
      end
    end
  end

  describe AMQ::Protocol::Basic do
    it "should be a subclass of Class" do
      AMQ::Protocol::Basic.superclass.should == AMQ::Protocol::Class
    end

    it "should have name equal to basic" do
      AMQ::Protocol::Basic.name.should eql("basic")
    end

    it "has method id equal to 60" do
      AMQ::Protocol::Basic.method_id.should == 60
    end
    describe AMQ::Protocol::Basic::Qos do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Qos.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.qos" do
        AMQ::Protocol::Basic::Qos.name.should eql("basic.qos")
      end

      it "has method id equal to 10" do
        AMQ::Protocol::Basic::Qos.method_id.should == 10
      end
    end

    describe AMQ::Protocol::Basic::QosOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::QosOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.qos-ok" do
        AMQ::Protocol::Basic::QosOk.name.should eql("basic.qos-ok")
      end

      it "has method id equal to 11" do
        AMQ::Protocol::Basic::QosOk.method_id.should == 11
      end
    end

    describe AMQ::Protocol::Basic::Consume do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Consume.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.consume" do
        AMQ::Protocol::Basic::Consume.name.should eql("basic.consume")
      end

      it "has method id equal to 20" do
        AMQ::Protocol::Basic::Consume.method_id.should == 20
      end
    end

    describe AMQ::Protocol::Basic::ConsumeOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::ConsumeOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.consume-ok" do
        AMQ::Protocol::Basic::ConsumeOk.name.should eql("basic.consume-ok")
      end

      it "has method id equal to 21" do
        AMQ::Protocol::Basic::ConsumeOk.method_id.should == 21
      end
    end

    describe AMQ::Protocol::Basic::Cancel do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Cancel.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.cancel" do
        AMQ::Protocol::Basic::Cancel.name.should eql("basic.cancel")
      end

      it "has method id equal to 30" do
        AMQ::Protocol::Basic::Cancel.method_id.should == 30
      end
    end

    describe AMQ::Protocol::Basic::CancelOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::CancelOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.cancel-ok" do
        AMQ::Protocol::Basic::CancelOk.name.should eql("basic.cancel-ok")
      end

      it "has method id equal to 31" do
        AMQ::Protocol::Basic::CancelOk.method_id.should == 31
      end
    end

    describe AMQ::Protocol::Basic::Publish do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Publish.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.publish" do
        AMQ::Protocol::Basic::Publish.name.should eql("basic.publish")
      end

      it "has method id equal to 40" do
        AMQ::Protocol::Basic::Publish.method_id.should == 40
      end
    end

    describe AMQ::Protocol::Basic::Return do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Return.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.return" do
        AMQ::Protocol::Basic::Return.name.should eql("basic.return")
      end

      it "has method id equal to 50" do
        AMQ::Protocol::Basic::Return.method_id.should == 50
      end
    end

    describe AMQ::Protocol::Basic::Deliver do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Deliver.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.deliver" do
        AMQ::Protocol::Basic::Deliver.name.should eql("basic.deliver")
      end

      it "has method id equal to 60" do
        AMQ::Protocol::Basic::Deliver.method_id.should == 60
      end
    end

    describe AMQ::Protocol::Basic::Get do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Get.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.get" do
        AMQ::Protocol::Basic::Get.name.should eql("basic.get")
      end

      it "has method id equal to 70" do
        AMQ::Protocol::Basic::Get.method_id.should == 70
      end
    end

    describe AMQ::Protocol::Basic::GetOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::GetOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.get-ok" do
        AMQ::Protocol::Basic::GetOk.name.should eql("basic.get-ok")
      end

      it "has method id equal to 71" do
        AMQ::Protocol::Basic::GetOk.method_id.should == 71
      end
    end

    describe AMQ::Protocol::Basic::GetEmpty do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::GetEmpty.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.get-empty" do
        AMQ::Protocol::Basic::GetEmpty.name.should eql("basic.get-empty")
      end

      it "has method id equal to 72" do
        AMQ::Protocol::Basic::GetEmpty.method_id.should == 72
      end
    end

    describe AMQ::Protocol::Basic::Ack do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Ack.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.ack" do
        AMQ::Protocol::Basic::Ack.name.should eql("basic.ack")
      end

      it "has method id equal to 80" do
        AMQ::Protocol::Basic::Ack.method_id.should == 80
      end
    end

    describe AMQ::Protocol::Basic::Reject do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Reject.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.reject" do
        AMQ::Protocol::Basic::Reject.name.should eql("basic.reject")
      end

      it "has method id equal to 90" do
        AMQ::Protocol::Basic::Reject.method_id.should == 90
      end
    end

    describe AMQ::Protocol::Basic::RecoverAsync do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::RecoverAsync.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.recover-async" do
        AMQ::Protocol::Basic::RecoverAsync.name.should eql("basic.recover-async")
      end

      it "has method id equal to 100" do
        AMQ::Protocol::Basic::RecoverAsync.method_id.should == 100
      end
    end

    describe AMQ::Protocol::Basic::Recover do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::Recover.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.recover" do
        AMQ::Protocol::Basic::Recover.name.should eql("basic.recover")
      end

      it "has method id equal to 110" do
        AMQ::Protocol::Basic::Recover.method_id.should == 110
      end
    end

    describe AMQ::Protocol::Basic::RecoverOk do
      it "should be a subclass of Method" do
        AMQ::Protocol::Basic::RecoverOk.superclass.should == AMQ::Protocol::Method
      end

      it "should have method name equal to basic.recover-ok" do
        AMQ::Protocol::Basic::RecoverOk.name.should eql("basic.recover-ok")
      end

      it "has method id equal to 111" do
        AMQ::Protocol::Basic::RecoverOk.method_id.should == 111
      end # it
    end # describe AMQ::Protocol::Basic::RecoverOk do
  end # describe AMQ::Protocol::Basic do
end # describe AMQ::Protocol do
