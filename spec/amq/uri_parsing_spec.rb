# encoding: utf-8

require "spec_helper"
require "amq/uri"

describe AMQ::URI, ".parse" do
  context "when schema is not one of [amqp, amqps]" do
    it "raises ArgumentError" do
      expect {
        described_class.parse_amqp_url("http://dev.rabbitmq.com")
      }.to raise_error(ArgumentError, /amqp or amqps schema/)
    end
  end


  it "handles amqp:// URIs w/o path part" do
    val = described_class.parse_amqp_url("amqp://dev.rabbitmq.com")

    expect(val[:vhost]).to be_nil # in this case, default / will be used
    expect(val[:host]).to eq("dev.rabbitmq.com")
    expect(val[:port]).to eq(5672)
    expect(val[:scheme]).to eq("amqp")
    expect(val[:ssl]).to be_falsey
  end

  it "handles amqps:// URIs w/o path part" do
    val = described_class.parse_amqp_url("amqps://dev.rabbitmq.com")

    expect(val[:vhost]).to be_nil
    expect(val[:host]).to eq("dev.rabbitmq.com")
    expect(val[:port]).to eq(5671)
    expect(val[:scheme]).to eq("amqps")
    expect(val[:ssl]).to be_truthy
  end


  context "when URI ends in a slash" do
    it "parses vhost as an empty string" do
      val = described_class.parse_amqp_url("amqp://dev.rabbitmq.com/")

      expect(val[:host]).to eq("dev.rabbitmq.com")
      expect(val[:port]).to eq(5672)
      expect(val[:scheme]).to eq("amqp")
      expect(val[:ssl]).to be_falsey
      expect(val[:vhost]).to eq("")
    end
  end


  context "when URI ends in /%2Fvault" do
    it "parses vhost as /vault" do
      val = described_class.parse_amqp_url("amqp://dev.rabbitmq.com/%2Fvault")

      expect(val[:host]).to eq("dev.rabbitmq.com")
      expect(val[:port]).to eq(5672)
      expect(val[:scheme]).to eq("amqp")
      expect(val[:ssl]).to be_falsey
      expect(val[:vhost]).to eq("/vault")
    end
  end


  context "when URI is amqp://dev.rabbitmq.com/a.path.without.slashes" do
    it "parses vhost as a.path.without.slashes" do
      val = described_class.parse_amqp_url("amqp://dev.rabbitmq.com/a.path.without.slashes")

      expect(val[:host]).to eq("dev.rabbitmq.com")
      expect(val[:port]).to eq(5672)
      expect(val[:scheme]).to eq("amqp")
      expect(val[:ssl]).to be_falsey
      expect(val[:vhost]).to eq("a.path.without.slashes")
    end
  end

  context "when URI is amqp://dev.rabbitmq.com/a/path/with/slashes" do
    it "raises an ArgumentError" do
      expect { described_class.parse_amqp_url("amqp://dev.rabbitmq.com/a/path/with/slashes") }.to raise_error(ArgumentError)
    end
  end


  context "when URI has username:password, for instance, amqp://hedgehog:t0ps3kr3t@hub.megacorp.internal" do
    it "parses them out" do
      val = described_class.parse_amqp_url("amqp://hedgehog:t0ps3kr3t@hub.megacorp.internal")

      expect(val[:host]).to eq("hub.megacorp.internal")
      expect(val[:port]).to eq(5672)
      expect(val[:scheme]).to eq("amqp")
      expect(val[:ssl]).to be_falsey
      expect(val[:user]).to eq("hedgehog")
      expect(val[:pass]).to eq("t0ps3kr3t")
      expect(val[:vhost]).to be_nil # in this case, default / will be used
    end
  end

  subject { described_class.parse(uri) }

  context "schema 'amqp'" do
    context "query parameters" do
      context "present" do
        let(:uri) { "amqp://rabbitmq?heartbeat=10&connection_timeout=100&channel_max=1000&auth_mechanism=plain&auth_mechanism=amqplain" }

        specify "parses parameters" do
          expect(subject[:heartbeat]).to eq(10)
          expect(subject[:connection_timeout]).to eq(100)
          expect(subject[:channel_max]).to eq(1000)
          expect(subject[:auth_mechanism]).to eq(["plain", "amqplain"])
        end
      end

      context "absent" do
        let(:uri) { "amqp://rabbitmq" }

        it "fallbacks to defaults" do
          expect(subject[:heartbeat]).to be_nil
          expect(subject[:connection_timeout]).to be_nil
          expect(subject[:channel_max]).to be_nil
          expect(subject[:auth_mechanism]).to be_empty
        end
      end

      context "tls parameters" do
        %w(verify fail_if_no_peer_cert cacertfile certfile keyfile).each do |tls_param|
          describe "'verify'" do
            let(:uri) { "amqp://rabbitmq?#{tls_param}=true" }

            it "raises ArgumentError" do
              expect { subject }.to raise_error(ArgumentError, /Only of use for the amqps scheme/)
            end
          end
        end
      end
    end
  end

  context "schema 'amqps'" do
    context "query parameters" do
      context "present" do
        let(:uri) { "amqps://rabbitmq?heartbeat=10&connection_timeout=100&channel_max=1000&auth_mechanism=plain&auth_mechanism=amqplain&verify=true&fail_if_no_peer_cert=true&cacertfile=/examples/tls/cacert.pem&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem" }

        it "parses parameters" do
          expect(subject[:heartbeat]).to eq(10)
          expect(subject[:connection_timeout]).to eq(100)
          expect(subject[:channel_max]).to eq(1000)
          expect(subject[:auth_mechanism]).to eq(["plain", "amqplain"])
          expect(subject[:verify]).to be_truthy
          expect(subject[:fail_if_no_peer_cert]).to be_truthy
          expect(subject[:cacertfile]).to eq("/examples/tls/cacert.pem")
          expect(subject[:certfile]).to eq("/examples/tls/client_cert.pem")
          expect(subject[:keyfile]).to eq("/examples/tls/client_key.pem")
        end
      end

      context "absent" do
        let(:uri) { "amqps://rabbitmq" }

        it "fallbacks to defaults" do
          expect(subject[:heartbeat]).to be_nil
          expect(subject[:connection_timeout]).to be_nil
          expect(subject[:channel_max]).to be_nil
          expect(subject[:auth_mechanism]).to be_empty
          expect(subject[:verify]).to be_falsey
          expect(subject[:fail_if_no_peer_cert]).to be_falsey
          expect(subject[:cacertfile]).to be_nil
          expect(subject[:certfile]).to be_nil
          expect(subject[:keyfile]).to be_nil
        end
      end
    end
  end
end
