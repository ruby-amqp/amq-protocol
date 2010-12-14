# encoding: utf-8

require_relative "../spec_helper.rb"

include AMQP

describe Protocol do
  it "should have PROTOCOL_VERSION constant" do
    Protocol::PROTOCOL_VERSION.should match(/^\d+\.\d+\.\d$/)
  end

  it "should have DEFAULT_PORT constant" do
    Protocol::DEFAULT_PORT.should be_kind_of(Integer)
  end

  it "should have PREAMBLE constant" do
    Protocol::PREAMBLE.should be_kind_of(String)
  end

  describe ".classes" do
    it "should include all the AMQP classes" do
      Protocol.classes.should include(Protocol::Queue)
    end
  end

  describe ".methods" do
    it "should include all the AMQP methods" do
      Protocol.methods.should include(Protocol::Queue::DeclareOk)
    end
  end

  describe Protocol::Error do
    it "should be an exception class" do
      Protocol::Error.should < Exception
    end
  end

  describe Protocol::Connection do
    it "should be a subclass of Protocol::Class" do
      Protocol::Connection.should < Protocol::Class
    end

    it "should have name equal to connection" do
      Protocol::Connection.name.should eql("connection")
    end

    it "should have method equal to TODO" do
      pending
      Protocol::Connection.method.should eql("TODO")
    end

    describe Protocol::Connection::Start do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::Start.should < Protocol::Method
      end

      it "should have method name equal to connection.start" do
        Protocol::Connection::Start.name.should eql("connection.start")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::Start.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::StartOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::StartOk.should < Protocol::Method
      end

      it "should have method name equal to connection.start-ok" do
        Protocol::Connection::StartOk.name.should eql("connection.start-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::StartOk.method.should eql("TODO")
      end

      describe ".encode" do
        it do
          result = Protocol::Connection::StartOk.encode({client: "AMQP Protocol"}, "PLAIN", "LOGINSguesPASSWORDSguest", "en_GB")
          result.should eql("\x00\n\x00\v\x00\x00\x00\x19\x06clientS\x00\x00\x00\rAMQP Protocol\x05PLAIN\x00\x00\x00\x18LOGINSguesPASSWORDSguest\x05en_GB")
        end
      end
    end

    describe Protocol::Connection::Secure do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::Secure.should < Protocol::Method
      end

      it "should have method name equal to connection.secure" do
        Protocol::Connection::Secure.name.should eql("connection.secure")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::Secure.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::SecureOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::SecureOk.should < Protocol::Method
      end

      it "should have method name equal to connection.secure-ok" do
        Protocol::Connection::SecureOk.name.should eql("connection.secure-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::SecureOk.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::Tune do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::Tune.should < Protocol::Method
      end

      it "should have method name equal to connection.tune" do
        Protocol::Connection::Tune.name.should eql("connection.tune")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::Tune.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::TuneOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::TuneOk.should < Protocol::Method
      end

      it "should have method name equal to connection.tune-ok" do
        Protocol::Connection::TuneOk.name.should eql("connection.tune-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::TuneOk.method.should eql("TODO")
      end

      describe ".encode" do
        it do
          result = Protocol::Connection::TuneOk.encode(0, 131072, 0)
          result.should eql("\x00\n\x00\x1F\x00\x00\x00\x02\x00\x00\x00\x00")
        end
      end
    end

    describe Protocol::Connection::Open do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::Open.should < Protocol::Method
      end

      it "should have method name equal to connection.open" do
        Protocol::Connection::Open.name.should eql("connection.open")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::Open.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::OpenOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::OpenOk.should < Protocol::Method
      end

      it "should have method name equal to connection.open-ok" do
        Protocol::Connection::OpenOk.name.should eql("connection.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::OpenOk.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::Close do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::Close.should < Protocol::Method
      end

      it "should have method name equal to connection.close" do
        Protocol::Connection::Close.name.should eql("connection.close")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::Close.method.should eql("TODO")
      end
    end

    describe Protocol::Connection::CloseOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Connection::CloseOk.should < Protocol::Method
      end

      it "should have method name equal to connection.close-ok" do
        Protocol::Connection::CloseOk.name.should eql("connection.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Connection::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe Protocol::Channel do
    it "should be a subclass of Protocol::Class" do
      Protocol::Channel.should < Protocol::Class
    end

    it "should have name equal to channel" do
      Protocol::Channel.name.should eql("channel")
    end

    it "should have method equal to TODO" do
      pending
      Protocol::Channel.method.should eql("TODO")
    end

    describe Protocol::Channel::Open do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::Open.should < Protocol::Method
      end

      it "should have method name equal to channel.open" do
        Protocol::Channel::Open.name.should eql("channel.open")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::Open.method.should eql("TODO")
      end
    end

    describe Protocol::Channel::OpenOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::OpenOk.should < Protocol::Method
      end

      it "should have method name equal to channel.open-ok" do
        Protocol::Channel::OpenOk.name.should eql("channel.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::OpenOk.method.should eql("TODO")
      end
    end

    describe Protocol::Channel::Flow do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::Flow.should < Protocol::Method
      end

      it "should have method name equal to channel.flow" do
        Protocol::Channel::Flow.name.should eql("channel.flow")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::Flow.method.should eql("TODO")
      end
    end

    describe Protocol::Channel::FlowOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::FlowOk.should < Protocol::Method
      end

      it "should have method name equal to channel.flow-ok" do
        Protocol::Channel::FlowOk.name.should eql("channel.flow-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::FlowOk.method.should eql("TODO")
      end
    end

    describe Protocol::Channel::Close do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::Close.should < Protocol::Method
      end

      it "should have method name equal to channel.close" do
        Protocol::Channel::Close.name.should eql("channel.close")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::Close.method.should eql("TODO")
      end
    end

    describe Protocol::Channel::CloseOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Channel::CloseOk.should < Protocol::Method
      end

      it "should have method name equal to channel.close-ok" do
        Protocol::Channel::CloseOk.name.should eql("channel.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Channel::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe Protocol::Exchange do
    it "should be a subclass of Protocol::Class" do
      Protocol::Exchange.should < Protocol::Class
    end

    it "should have name equal to exchange" do
      Protocol::Exchange.name.should eql("exchange")
    end

    it "should have method equal to TODO" do
      pending
      Protocol::Exchange.method.should eql("TODO")
    end

    describe Protocol::Exchange::Declare do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::Declare.should < Protocol::Method
      end

      it "should have method name equal to exchange.declare" do
        Protocol::Exchange::Declare.name.should eql("exchange.declare")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::Declare.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::DeclareOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::DeclareOk.should < Protocol::Method
      end

      it "should have method name equal to exchange.declare-ok" do
        Protocol::Exchange::DeclareOk.name.should eql("exchange.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::DeclareOk.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::Delete do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::Delete.should < Protocol::Method
      end

      it "should have method name equal to exchange.delete" do
        Protocol::Exchange::Delete.name.should eql("exchange.delete")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::Delete.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::DeleteOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::DeleteOk.should < Protocol::Method
      end

      it "should have method name equal to exchange.delete-ok" do
        Protocol::Exchange::DeleteOk.name.should eql("exchange.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::DeleteOk.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::Bind do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::Bind.should < Protocol::Method
      end

      it "should have method name equal to exchange.bind" do
        Protocol::Exchange::Bind.name.should eql("exchange.bind")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::Bind.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::BindOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::BindOk.should < Protocol::Method
      end

      it "should have method name equal to exchange.bind-ok" do
        Protocol::Exchange::BindOk.name.should eql("exchange.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::BindOk.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::Unbind do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::Unbind.should < Protocol::Method
      end

      it "should have method name equal to exchange.unbind" do
        Protocol::Exchange::Unbind.name.should eql("exchange.unbind")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::Unbind.method.should eql("TODO")
      end
    end

    describe Protocol::Exchange::UnbindOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Exchange::UnbindOk.should < Protocol::Method
      end

      it "should have method name equal to exchange.unbind-ok" do
        Protocol::Exchange::UnbindOk.name.should eql("exchange.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Exchange::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe Protocol::Queue do
    it "should be a subclass of Protocol::Class" do
      Protocol::Queue.should < Protocol::Class
    end

    it "should have name equal to queue" do
      Protocol::Queue.name.should eql("queue")
    end

    it "should have method equal to TODO" do
      pending
      Protocol::Queue.method.should eql("TODO")
    end

    describe Protocol::Queue::Declare do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::Declare.should < Protocol::Method
      end

      it "should have method name equal to queue.declare" do
        Protocol::Queue::Declare.name.should eql("queue.declare")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::Declare.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::DeclareOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::DeclareOk.should < Protocol::Method
      end

      it "should have method name equal to queue.declare-ok" do
        Protocol::Queue::DeclareOk.name.should eql("queue.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::DeclareOk.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::Bind do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::Bind.should < Protocol::Method
      end

      it "should have method name equal to queue.bind" do
        Protocol::Queue::Bind.name.should eql("queue.bind")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::Bind.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::BindOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::BindOk.should < Protocol::Method
      end

      it "should have method name equal to queue.bind-ok" do
        Protocol::Queue::BindOk.name.should eql("queue.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::BindOk.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::Purge do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::Purge.should < Protocol::Method
      end

      it "should have method name equal to queue.purge" do
        Protocol::Queue::Purge.name.should eql("queue.purge")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::Purge.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::PurgeOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::PurgeOk.should < Protocol::Method
      end

      it "should have method name equal to queue.purge-ok" do
        Protocol::Queue::PurgeOk.name.should eql("queue.purge-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::PurgeOk.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::Delete do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::Delete.should < Protocol::Method
      end

      it "should have method name equal to queue.delete" do
        Protocol::Queue::Delete.name.should eql("queue.delete")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::Delete.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::DeleteOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::DeleteOk.should < Protocol::Method
      end

      it "should have method name equal to queue.delete-ok" do
        Protocol::Queue::DeleteOk.name.should eql("queue.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::DeleteOk.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::Unbind do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::Unbind.should < Protocol::Method
      end

      it "should have method name equal to queue.unbind" do
        Protocol::Queue::Unbind.name.should eql("queue.unbind")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::Unbind.method.should eql("TODO")
      end
    end

    describe Protocol::Queue::UnbindOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Queue::UnbindOk.should < Protocol::Method
      end

      it "should have method name equal to queue.unbind-ok" do
        Protocol::Queue::UnbindOk.name.should eql("queue.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Queue::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe Protocol::Basic do
    it "should be a subclass of Protocol::Class" do
      Protocol::Basic.should < Protocol::Class
    end

    it "should have name equal to basic" do
      Protocol::Basic.name.should eql("basic")
    end

    it "should have method equal to TODO" do
      pending
      Protocol::Basic.method.should eql("TODO")
    end
    describe Protocol::Basic::Qos do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Qos.should < Protocol::Method
      end

      it "should have method name equal to basic.qos" do
        Protocol::Basic::Qos.name.should eql("basic.qos")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Qos.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::QosOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::QosOk.should < Protocol::Method
      end

      it "should have method name equal to basic.qos-ok" do
        Protocol::Basic::QosOk.name.should eql("basic.qos-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::QosOk.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Consume do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Consume.should < Protocol::Method
      end

      it "should have method name equal to basic.consume" do
        Protocol::Basic::Consume.name.should eql("basic.consume")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Consume.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::ConsumeOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::ConsumeOk.should < Protocol::Method
      end

      it "should have method name equal to basic.consume-ok" do
        Protocol::Basic::ConsumeOk.name.should eql("basic.consume-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::ConsumeOk.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Cancel do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Cancel.should < Protocol::Method
      end

      it "should have method name equal to basic.cancel" do
        Protocol::Basic::Cancel.name.should eql("basic.cancel")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Cancel.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::CancelOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::CancelOk.should < Protocol::Method
      end

      it "should have method name equal to basic.cancel-ok" do
        Protocol::Basic::CancelOk.name.should eql("basic.cancel-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::CancelOk.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Publish do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Publish.should < Protocol::Method
      end

      it "should have method name equal to basic.publish" do
        Protocol::Basic::Publish.name.should eql("basic.publish")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Publish.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Return do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Return.should < Protocol::Method
      end

      it "should have method name equal to basic.return" do
        Protocol::Basic::Return.name.should eql("basic.return")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Return.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Deliver do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Deliver.should < Protocol::Method
      end

      it "should have method name equal to basic.deliver" do
        Protocol::Basic::Deliver.name.should eql("basic.deliver")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Deliver.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Get do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Get.should < Protocol::Method
      end

      it "should have method name equal to basic.get" do
        Protocol::Basic::Get.name.should eql("basic.get")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Get.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::GetOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::GetOk.should < Protocol::Method
      end

      it "should have method name equal to basic.get-ok" do
        Protocol::Basic::GetOk.name.should eql("basic.get-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::GetOk.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::GetEmpty do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::GetEmpty.should < Protocol::Method
      end

      it "should have method name equal to basic.get-empty" do
        Protocol::Basic::GetEmpty.name.should eql("basic.get-empty")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::GetEmpty.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Ack do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Ack.should < Protocol::Method
      end

      it "should have method name equal to basic.ack" do
        Protocol::Basic::Ack.name.should eql("basic.ack")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Ack.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Reject do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Reject.should < Protocol::Method
      end

      it "should have method name equal to basic.reject" do
        Protocol::Basic::Reject.name.should eql("basic.reject")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Reject.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::RecoverAsync do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::RecoverAsync.should < Protocol::Method
      end

      it "should have method name equal to basic.recover-async" do
        Protocol::Basic::RecoverAsync.name.should eql("basic.recover-async")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::RecoverAsync.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::Recover do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::Recover.should < Protocol::Method
      end

      it "should have method name equal to basic.recover" do
        Protocol::Basic::Recover.name.should eql("basic.recover")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::Recover.method.should eql("TODO")
      end
    end

    describe Protocol::Basic::RecoverOk do
      it "should be a subclass of Protocol::Method" do
        Protocol::Basic::RecoverOk.should < Protocol::Method
      end

      it "should have method name equal to basic.recover-ok" do
        Protocol::Basic::RecoverOk.name.should eql("basic.recover-ok")
      end

      it "should have method equal to TODO" do
        pending
        Protocol::Basic::RecoverOk.method.should eql("TODO")
      end
    end
  end
end
