# encoding: utf-8

require_relative "../spec_helper.rb"

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

  describe ".classes" do
    it "should include all the AMQP classes" do
      AMQ::Protocol.classes.should include(Queue)
    end
  end

  describe ".methods" do
    it "should include all the AMQP methods" do
      AMQ::Protocol.methods.should include(Queue::DeclareOk)
    end
  end

  describe AMQ::Protocol::Error do
    it "should be an exception class" do
      AMQ::Protocol::Error.should < Exception
    end
  end

  describe AMQ::Protocol::Connection do
    it "should be a subclass of Class" do
      Connection.should < Class
    end

    it "should have name equal to connection" do
      Connection.name.should eql("connection")
    end

    it "should have method equal to TODO" do
      pending
      Connection.method.should eql("TODO")
    end

    describe AMQ::Protocol::Connection::Start do
      it "should be a subclass of Method" do
        Connection::Start.should < Method
      end

      it "should have method name equal to connection.start" do
        Connection::Start.name.should eql("connection.start")
      end

      it "should have method equal to TODO" do
        pending
        Connection::Start.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::StartOk do
      it "should be a subclass of Method" do
        Connection::StartOk.should < Method
      end

      it "should have method name equal to connection.start-ok" do
        Connection::StartOk.name.should eql("connection.start-ok")
      end

      it "should have method equal to TODO" do
        pending
        Connection::StartOk.method.should eql("TODO")
      end

      describe ".encode" do
        it do
          result = Connection::StartOk.encode({client: "AMQ Protocol"}, "PLAIN", "LOGINSguesPASSWORDSguest", "en_GB")
          result.should eql("\x00\n\x00\v\x00\x00\x00\x18\x06clientS\x00\x00\x00\fAMQ Protocol\x05PLAIN\x00\x00\x00\x18LOGINSguesPASSWORDSguest\x05en_GB")
        end
      end
    end

    describe AMQ::Protocol::Connection::Secure do
      it "should be a subclass of Method" do
        Connection::Secure.should < Method
      end

      it "should have method name equal to connection.secure" do
        Connection::Secure.name.should eql("connection.secure")
      end

      it "should have method equal to TODO" do
        pending
        Connection::Secure.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::SecureOk do
      it "should be a subclass of Method" do
        Connection::SecureOk.should < Method
      end

      it "should have method name equal to connection.secure-ok" do
        Connection::SecureOk.name.should eql("connection.secure-ok")
      end

      it "should have method equal to TODO" do
        pending
        Connection::SecureOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::Tune do
      it "should be a subclass of Method" do
        Connection::Tune.should < Method
      end

      it "should have method name equal to connection.tune" do
        Connection::Tune.name.should eql("connection.tune")
      end

      it "should have method equal to TODO" do
        pending
        Connection::Tune.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::TuneOk do
      it "should be a subclass of Method" do
        Connection::TuneOk.should < Method
      end

      it "should have method name equal to connection.tune-ok" do
        Connection::TuneOk.name.should eql("connection.tune-ok")
      end

      it "should have method equal to TODO" do
        pending
        Connection::TuneOk.method.should eql("TODO")
      end

      describe ".encode" do
        it do
          result = Connection::TuneOk.encode(0, 131072, 0)
          result.should eql("\x00\n\x00\x1F\x00\x00\x00\x02\x00\x00\x00\x00")
        end
      end
    end

    describe AMQ::Protocol::Connection::Open do
      it "should be a subclass of Method" do
        Connection::Open.should < Method
      end

      it "should have method name equal to connection.open" do
        Connection::Open.name.should eql("connection.open")
      end

      it "should have method equal to TODO" do
        pending
        Connection::Open.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::OpenOk do
      it "should be a subclass of Method" do
        Connection::OpenOk.should < Method
      end

      it "should have method name equal to connection.open-ok" do
        Connection::OpenOk.name.should eql("connection.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        Connection::OpenOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::Close do
      it "should be a subclass of Method" do
        Connection::Close.should < Method
      end

      it "should have method name equal to connection.close" do
        Connection::Close.name.should eql("connection.close")
      end

      it "should have method equal to TODO" do
        pending
        Connection::Close.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Connection::CloseOk do
      it "should be a subclass of Method" do
        Connection::CloseOk.should < Method
      end

      it "should have method name equal to connection.close-ok" do
        Connection::CloseOk.name.should eql("connection.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        Connection::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe AMQ::Protocol::Channel do
    it "should be a subclass of Class" do
      Channel.should < Class
    end

    it "should have name equal to channel" do
      Channel.name.should eql("channel")
    end

    it "should have method equal to TODO" do
      pending
      Channel.method.should eql("TODO")
    end

    describe AMQ::Protocol::Channel::Open do
      it "should be a subclass of Method" do
        Channel::Open.should < Method
      end

      it "should have method name equal to channel.open" do
        Channel::Open.name.should eql("channel.open")
      end

      it "should have method equal to TODO" do
        pending
        Channel::Open.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Channel::OpenOk do
      it "should be a subclass of Method" do
        Channel::OpenOk.should < Method
      end

      it "should have method name equal to channel.open-ok" do
        Channel::OpenOk.name.should eql("channel.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        Channel::OpenOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Channel::Flow do
      it "should be a subclass of Method" do
        Channel::Flow.should < Method
      end

      it "should have method name equal to channel.flow" do
        Channel::Flow.name.should eql("channel.flow")
      end

      it "should have method equal to TODO" do
        pending
        Channel::Flow.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Channel::FlowOk do
      it "should be a subclass of Method" do
        Channel::FlowOk.should < Method
      end

      it "should have method name equal to channel.flow-ok" do
        Channel::FlowOk.name.should eql("channel.flow-ok")
      end

      it "should have method equal to TODO" do
        pending
        Channel::FlowOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Channel::Close do
      it "should be a subclass of Method" do
        Channel::Close.should < Method
      end

      it "should have method name equal to channel.close" do
        Channel::Close.name.should eql("channel.close")
      end

      it "should have method equal to TODO" do
        pending
        Channel::Close.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Channel::CloseOk do
      it "should be a subclass of Method" do
        Channel::CloseOk.should < Method
      end

      it "should have method name equal to channel.close-ok" do
        Channel::CloseOk.name.should eql("channel.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        Channel::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe AMQ::Protocol::Exchange do
    it "should be a subclass of Class" do
      Exchange.should < Class
    end

    it "should have name equal to exchange" do
      Exchange.name.should eql("exchange")
    end

    it "should have method equal to TODO" do
      pending
      Exchange.method.should eql("TODO")
    end

    describe AMQ::Protocol::Exchange::Declare do
      it "should be a subclass of Method" do
        Exchange::Declare.should < Method
      end

      it "should have method name equal to exchange.declare" do
        Exchange::Declare.name.should eql("exchange.declare")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::Declare.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::DeclareOk do
      it "should be a subclass of Method" do
        Exchange::DeclareOk.should < Method
      end

      it "should have method name equal to exchange.declare-ok" do
        Exchange::DeclareOk.name.should eql("exchange.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::DeclareOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::Delete do
      it "should be a subclass of Method" do
        Exchange::Delete.should < Method
      end

      it "should have method name equal to exchange.delete" do
        Exchange::Delete.name.should eql("exchange.delete")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::Delete.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::DeleteOk do
      it "should be a subclass of Method" do
        Exchange::DeleteOk.should < Method
      end

      it "should have method name equal to exchange.delete-ok" do
        Exchange::DeleteOk.name.should eql("exchange.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::DeleteOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::Bind do
      it "should be a subclass of Method" do
        Exchange::Bind.should < Method
      end

      it "should have method name equal to exchange.bind" do
        Exchange::Bind.name.should eql("exchange.bind")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::Bind.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::BindOk do
      it "should be a subclass of Method" do
        Exchange::BindOk.should < Method
      end

      it "should have method name equal to exchange.bind-ok" do
        Exchange::BindOk.name.should eql("exchange.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::BindOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::Unbind do
      it "should be a subclass of Method" do
        Exchange::Unbind.should < Method
      end

      it "should have method name equal to exchange.unbind" do
        Exchange::Unbind.name.should eql("exchange.unbind")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::Unbind.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Exchange::UnbindOk do
      it "should be a subclass of Method" do
        Exchange::UnbindOk.should < Method
      end

      it "should have method name equal to exchange.unbind-ok" do
        Exchange::UnbindOk.name.should eql("exchange.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Exchange::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe AMQ::Protocol::Queue do
    it "should be a subclass of Class" do
      Queue.should < Class
    end

    it "should have name equal to queue" do
      Queue.name.should eql("queue")
    end

    it "should have method equal to TODO" do
      pending
      Queue.method.should eql("TODO")
    end

    describe AMQ::Protocol::Queue::Declare do
      it "should be a subclass of Method" do
        Queue::Declare.should < Method
      end

      it "should have method name equal to queue.declare" do
        Queue::Declare.name.should eql("queue.declare")
      end

      it "should have method equal to TODO" do
        pending
        Queue::Declare.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::DeclareOk do
      it "should be a subclass of Method" do
        Queue::DeclareOk.should < Method
      end

      it "should have method name equal to queue.declare-ok" do
        Queue::DeclareOk.name.should eql("queue.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        Queue::DeclareOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::Bind do
      it "should be a subclass of Method" do
        Queue::Bind.should < Method
      end

      it "should have method name equal to queue.bind" do
        Queue::Bind.name.should eql("queue.bind")
      end

      it "should have method equal to TODO" do
        pending
        Queue::Bind.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::BindOk do
      it "should be a subclass of Method" do
        Queue::BindOk.should < Method
      end

      it "should have method name equal to queue.bind-ok" do
        Queue::BindOk.name.should eql("queue.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Queue::BindOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::Purge do
      it "should be a subclass of Method" do
        Queue::Purge.should < Method
      end

      it "should have method name equal to queue.purge" do
        Queue::Purge.name.should eql("queue.purge")
      end

      it "should have method equal to TODO" do
        pending
        Queue::Purge.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::PurgeOk do
      it "should be a subclass of Method" do
        Queue::PurgeOk.should < Method
      end

      it "should have method name equal to queue.purge-ok" do
        Queue::PurgeOk.name.should eql("queue.purge-ok")
      end

      it "should have method equal to TODO" do
        pending
        Queue::PurgeOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::Delete do
      it "should be a subclass of Method" do
        Queue::Delete.should < Method
      end

      it "should have method name equal to queue.delete" do
        Queue::Delete.name.should eql("queue.delete")
      end

      it "should have method equal to TODO" do
        pending
        Queue::Delete.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::DeleteOk do
      it "should be a subclass of Method" do
        Queue::DeleteOk.should < Method
      end

      it "should have method name equal to queue.delete-ok" do
        Queue::DeleteOk.name.should eql("queue.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        Queue::DeleteOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::Unbind do
      it "should be a subclass of Method" do
        Queue::Unbind.should < Method
      end

      it "should have method name equal to queue.unbind" do
        Queue::Unbind.name.should eql("queue.unbind")
      end

      it "should have method equal to TODO" do
        pending
        Queue::Unbind.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Queue::UnbindOk do
      it "should be a subclass of Method" do
        Queue::UnbindOk.should < Method
      end

      it "should have method name equal to queue.unbind-ok" do
        Queue::UnbindOk.name.should eql("queue.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        Queue::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe AMQ::Protocol::Basic do
    it "should be a subclass of Class" do
      Basic.should < Class
    end

    it "should have name equal to basic" do
      Basic.name.should eql("basic")
    end

    it "should have method equal to TODO" do
      pending
      Basic.method.should eql("TODO")
    end
    describe AMQ::Protocol::Basic::Qos do
      it "should be a subclass of Method" do
        Basic::Qos.should < Method
      end

      it "should have method name equal to basic.qos" do
        Basic::Qos.name.should eql("basic.qos")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Qos.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::QosOk do
      it "should be a subclass of Method" do
        Basic::QosOk.should < Method
      end

      it "should have method name equal to basic.qos-ok" do
        Basic::QosOk.name.should eql("basic.qos-ok")
      end

      it "should have method equal to TODO" do
        pending
        Basic::QosOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Consume do
      it "should be a subclass of Method" do
        Basic::Consume.should < Method
      end

      it "should have method name equal to basic.consume" do
        Basic::Consume.name.should eql("basic.consume")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Consume.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::ConsumeOk do
      it "should be a subclass of Method" do
        Basic::ConsumeOk.should < Method
      end

      it "should have method name equal to basic.consume-ok" do
        Basic::ConsumeOk.name.should eql("basic.consume-ok")
      end

      it "should have method equal to TODO" do
        pending
        Basic::ConsumeOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Cancel do
      it "should be a subclass of Method" do
        Basic::Cancel.should < Method
      end

      it "should have method name equal to basic.cancel" do
        Basic::Cancel.name.should eql("basic.cancel")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Cancel.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::CancelOk do
      it "should be a subclass of Method" do
        Basic::CancelOk.should < Method
      end

      it "should have method name equal to basic.cancel-ok" do
        Basic::CancelOk.name.should eql("basic.cancel-ok")
      end

      it "should have method equal to TODO" do
        pending
        Basic::CancelOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Publish do
      it "should be a subclass of Method" do
        Basic::Publish.should < Method
      end

      it "should have method name equal to basic.publish" do
        Basic::Publish.name.should eql("basic.publish")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Publish.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Return do
      it "should be a subclass of Method" do
        Basic::Return.should < Method
      end

      it "should have method name equal to basic.return" do
        Basic::Return.name.should eql("basic.return")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Return.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Deliver do
      it "should be a subclass of Method" do
        Basic::Deliver.should < Method
      end

      it "should have method name equal to basic.deliver" do
        Basic::Deliver.name.should eql("basic.deliver")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Deliver.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Get do
      it "should be a subclass of Method" do
        Basic::Get.should < Method
      end

      it "should have method name equal to basic.get" do
        Basic::Get.name.should eql("basic.get")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Get.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::GetOk do
      it "should be a subclass of Method" do
        Basic::GetOk.should < Method
      end

      it "should have method name equal to basic.get-ok" do
        Basic::GetOk.name.should eql("basic.get-ok")
      end

      it "should have method equal to TODO" do
        pending
        Basic::GetOk.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::GetEmpty do
      it "should be a subclass of Method" do
        Basic::GetEmpty.should < Method
      end

      it "should have method name equal to basic.get-empty" do
        Basic::GetEmpty.name.should eql("basic.get-empty")
      end

      it "should have method equal to TODO" do
        pending
        Basic::GetEmpty.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Ack do
      it "should be a subclass of Method" do
        Basic::Ack.should < Method
      end

      it "should have method name equal to basic.ack" do
        Basic::Ack.name.should eql("basic.ack")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Ack.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Reject do
      it "should be a subclass of Method" do
        Basic::Reject.should < Method
      end

      it "should have method name equal to basic.reject" do
        Basic::Reject.name.should eql("basic.reject")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Reject.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::RecoverAsync do
      it "should be a subclass of Method" do
        Basic::RecoverAsync.should < Method
      end

      it "should have method name equal to basic.recover-async" do
        Basic::RecoverAsync.name.should eql("basic.recover-async")
      end

      it "should have method equal to TODO" do
        pending
        Basic::RecoverAsync.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::Recover do
      it "should be a subclass of Method" do
        Basic::Recover.should < Method
      end

      it "should have method name equal to basic.recover" do
        Basic::Recover.name.should eql("basic.recover")
      end

      it "should have method equal to TODO" do
        pending
        Basic::Recover.method.should eql("TODO")
      end
    end

    describe AMQ::Protocol::Basic::RecoverOk do
      it "should be a subclass of Method" do
        Basic::RecoverOk.should < Method
      end

      it "should have method name equal to basic.recover-ok" do
        Basic::RecoverOk.name.should eql("basic.recover-ok")
      end

      it "should have method equal to TODO" do
        pending
        Basic::RecoverOk.method.should eql("TODO")
      end
    end
  end
end
