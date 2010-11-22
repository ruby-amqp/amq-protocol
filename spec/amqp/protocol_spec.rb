# encoding: utf-8

require_relative "../spec_helper.rb"

describe AMQP::Protocol do
  it "should have PROTOCOL_VERSION constant" do
    AMQP::Protocol::PROTOCOL_VERSION.should match(/^\d+\.\d+\.\d$/)
  end

  it "should have DEFAULT_PORT constant" do
    AMQP::Protocol::DEFAULT_PORT.should be_kind_of(Integer)
  end

  it "should have PREAMBLE constant" do
    AMQP::Protocol::PREAMBLE.should be_kind_of(String)
  end

  describe ".classes" do
    it "should include all the AMQP classes" do
      AMQP::Protocol.classes.should include(AMQP::Protocol::Queue)
    end
  end

  describe ".methods" do
    it "should include all the AMQP methods" do
      AMQP::Protocol.methods.should include(AMQP::Protocol::Queue::DeclareOk)
    end
  end

  describe AMQP::Protocol::Error do
    it "should be an exception class" do
      AMQP::Protocol::Error.should < Exception
    end
  end

  describe AMQP::Protocol::Connection do
    it "should be a subclass of AMQP::Protocol::Class" do
      AMQP::Protocol::Connection.should < AMQP::Protocol::Class
    end

    it "should have name equal to connection" do
      AMQP::Protocol::Connection.name.should eql("connection")
    end

    it "should have method equal to TODO" do
      pending
      AMQP::Protocol::Connection.method.should eql("TODO")
    end

    describe AMQP::Protocol::Connection::Start do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::Start.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.start" do
        AMQP::Protocol::Connection::Start.name.should eql("connection.start")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::Start.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::StartOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::StartOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.start-ok" do
        AMQP::Protocol::Connection::StartOk.name.should eql("connection.start-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::StartOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::Secure do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::Secure.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.secure" do
        AMQP::Protocol::Connection::Secure.name.should eql("connection.secure")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::Secure.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::SecureOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::SecureOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.secure-ok" do
        AMQP::Protocol::Connection::SecureOk.name.should eql("connection.secure-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::SecureOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::Tune do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::Tune.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.tune" do
        AMQP::Protocol::Connection::Tune.name.should eql("connection.tune")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::Tune.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::TuneOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::TuneOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.tune-ok" do
        AMQP::Protocol::Connection::TuneOk.name.should eql("connection.tune-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::TuneOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::Open do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::Open.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.open" do
        AMQP::Protocol::Connection::Open.name.should eql("connection.open")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::Open.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::OpenOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::OpenOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.open-ok" do
        AMQP::Protocol::Connection::OpenOk.name.should eql("connection.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::OpenOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::Close do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::Close.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.close" do
        AMQP::Protocol::Connection::Close.name.should eql("connection.close")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::Close.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Connection::CloseOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Connection::CloseOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to connection.close-ok" do
        AMQP::Protocol::Connection::CloseOk.name.should eql("connection.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Connection::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe AMQP::Protocol::Channel do
    it "should be a subclass of AMQP::Protocol::Class" do
      AMQP::Protocol::Channel.should < AMQP::Protocol::Class
    end

    it "should have name equal to channel" do
      AMQP::Protocol::Channel.name.should eql("channel")
    end

    it "should have method equal to TODO" do
      pending
      AMQP::Protocol::Channel.method.should eql("TODO")
    end

    describe AMQP::Protocol::Channel::Open do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::Open.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.open" do
        AMQP::Protocol::Channel::Open.name.should eql("channel.open")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::Open.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Channel::OpenOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::OpenOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.open-ok" do
        AMQP::Protocol::Channel::OpenOk.name.should eql("channel.open-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::OpenOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Channel::Flow do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::Flow.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.flow" do
        AMQP::Protocol::Channel::Flow.name.should eql("channel.flow")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::Flow.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Channel::FlowOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::FlowOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.flow-ok" do
        AMQP::Protocol::Channel::FlowOk.name.should eql("channel.flow-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::FlowOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Channel::Close do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::Close.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.close" do
        AMQP::Protocol::Channel::Close.name.should eql("channel.close")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::Close.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Channel::CloseOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Channel::CloseOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to channel.close-ok" do
        AMQP::Protocol::Channel::CloseOk.name.should eql("channel.close-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Channel::CloseOk.method.should eql("TODO")
      end
    end
  end

  describe AMQP::Protocol::Exchange do
    it "should be a subclass of AMQP::Protocol::Class" do
      AMQP::Protocol::Exchange.should < AMQP::Protocol::Class
    end

    it "should have name equal to exchange" do
      AMQP::Protocol::Exchange.name.should eql("exchange")
    end

    it "should have method equal to TODO" do
      pending
      AMQP::Protocol::Exchange.method.should eql("TODO")
    end

    describe AMQP::Protocol::Exchange::Declare do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::Declare.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.declare" do
        AMQP::Protocol::Exchange::Declare.name.should eql("exchange.declare")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::Declare.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::DeclareOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::DeclareOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.declare-ok" do
        AMQP::Protocol::Exchange::DeclareOk.name.should eql("exchange.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::DeclareOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::Delete do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::Delete.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.delete" do
        AMQP::Protocol::Exchange::Delete.name.should eql("exchange.delete")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::Delete.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::DeleteOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::DeleteOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.delete-ok" do
        AMQP::Protocol::Exchange::DeleteOk.name.should eql("exchange.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::DeleteOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::Bind do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::Bind.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.bind" do
        AMQP::Protocol::Exchange::Bind.name.should eql("exchange.bind")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::Bind.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::BindOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::BindOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.bind-ok" do
        AMQP::Protocol::Exchange::BindOk.name.should eql("exchange.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::BindOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::Unbind do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::Unbind.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.unbind" do
        AMQP::Protocol::Exchange::Unbind.name.should eql("exchange.unbind")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::Unbind.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Exchange::UnbindOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Exchange::UnbindOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to exchange.unbind-ok" do
        AMQP::Protocol::Exchange::UnbindOk.name.should eql("exchange.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Exchange::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe AMQP::Protocol::Queue do
    it "should be a subclass of AMQP::Protocol::Class" do
      AMQP::Protocol::Queue.should < AMQP::Protocol::Class
    end

    it "should have name equal to queue" do
      AMQP::Protocol::Queue.name.should eql("queue")
    end

    it "should have method equal to TODO" do
      pending
      AMQP::Protocol::Queue.method.should eql("TODO")
    end

    describe AMQP::Protocol::Queue::Declare do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::Declare.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.declare" do
        AMQP::Protocol::Queue::Declare.name.should eql("queue.declare")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::Declare.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::DeclareOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::DeclareOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.declare-ok" do
        AMQP::Protocol::Queue::DeclareOk.name.should eql("queue.declare-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::DeclareOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::Bind do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::Bind.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.bind" do
        AMQP::Protocol::Queue::Bind.name.should eql("queue.bind")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::Bind.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::BindOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::BindOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.bind-ok" do
        AMQP::Protocol::Queue::BindOk.name.should eql("queue.bind-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::BindOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::Purge do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::Purge.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.purge" do
        AMQP::Protocol::Queue::Purge.name.should eql("queue.purge")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::Purge.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::PurgeOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::PurgeOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.purge-ok" do
        AMQP::Protocol::Queue::PurgeOk.name.should eql("queue.purge-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::PurgeOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::Delete do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::Delete.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.delete" do
        AMQP::Protocol::Queue::Delete.name.should eql("queue.delete")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::Delete.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::DeleteOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::DeleteOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.delete-ok" do
        AMQP::Protocol::Queue::DeleteOk.name.should eql("queue.delete-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::DeleteOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::Unbind do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::Unbind.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.unbind" do
        AMQP::Protocol::Queue::Unbind.name.should eql("queue.unbind")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::Unbind.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Queue::UnbindOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Queue::UnbindOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to queue.unbind-ok" do
        AMQP::Protocol::Queue::UnbindOk.name.should eql("queue.unbind-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Queue::UnbindOk.method.should eql("TODO")
      end
    end
  end

  describe AMQP::Protocol::Basic do
    it "should be a subclass of AMQP::Protocol::Class" do
      AMQP::Protocol::Basic.should < AMQP::Protocol::Class
    end

    it "should have name equal to basic" do
      AMQP::Protocol::Basic.name.should eql("basic")
    end

    it "should have method equal to TODO" do
      pending
      AMQP::Protocol::Basic.method.should eql("TODO")
    end
    describe AMQP::Protocol::Basic::Qos do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Qos.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.qos" do
        AMQP::Protocol::Basic::Qos.name.should eql("basic.qos")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Qos.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::QosOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::QosOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.qos-ok" do
        AMQP::Protocol::Basic::QosOk.name.should eql("basic.qos-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::QosOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Consume do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Consume.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.consume" do
        AMQP::Protocol::Basic::Consume.name.should eql("basic.consume")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Consume.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::ConsumeOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::ConsumeOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.consume-ok" do
        AMQP::Protocol::Basic::ConsumeOk.name.should eql("basic.consume-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::ConsumeOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Cancel do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Cancel.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.cancel" do
        AMQP::Protocol::Basic::Cancel.name.should eql("basic.cancel")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Cancel.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::CancelOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::CancelOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.cancel-ok" do
        AMQP::Protocol::Basic::CancelOk.name.should eql("basic.cancel-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::CancelOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Publish do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Publish.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.publish" do
        AMQP::Protocol::Basic::Publish.name.should eql("basic.publish")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Publish.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Return do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Return.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.return" do
        AMQP::Protocol::Basic::Return.name.should eql("basic.return")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Return.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Deliver do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Deliver.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.deliver" do
        AMQP::Protocol::Basic::Deliver.name.should eql("basic.deliver")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Deliver.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Get do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Get.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.get" do
        AMQP::Protocol::Basic::Get.name.should eql("basic.get")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Get.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::GetOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::GetOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.get-ok" do
        AMQP::Protocol::Basic::GetOk.name.should eql("basic.get-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::GetOk.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::GetEmpty do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::GetEmpty.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.get-empty" do
        AMQP::Protocol::Basic::GetEmpty.name.should eql("basic.get-empty")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::GetEmpty.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Ack do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Ack.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.ack" do
        AMQP::Protocol::Basic::Ack.name.should eql("basic.ack")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Ack.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Reject do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Reject.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.reject" do
        AMQP::Protocol::Basic::Reject.name.should eql("basic.reject")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Reject.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::RecoverAsync do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::RecoverAsync.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.recover-async" do
        AMQP::Protocol::Basic::RecoverAsync.name.should eql("basic.recover-async")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::RecoverAsync.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::Recover do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::Recover.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.recover" do
        AMQP::Protocol::Basic::Recover.name.should eql("basic.recover")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::Recover.method.should eql("TODO")
      end
    end

    describe AMQP::Protocol::Basic::RecoverOk do
      it "should be a subclass of AMQP::Protocol::Method" do
        AMQP::Protocol::Basic::RecoverOk.should < AMQP::Protocol::Method
      end

      it "should have method name equal to basic.recover-ok" do
        AMQP::Protocol::Basic::RecoverOk.name.should eql("basic.recover-ok")
      end

      it "should have method equal to TODO" do
        pending
        AMQP::Protocol::Basic::RecoverOk.method.should eql("TODO")
      end
    end
  end
end
