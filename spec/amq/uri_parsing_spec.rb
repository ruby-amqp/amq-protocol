require "amq/uri"

RSpec.describe AMQ::URI do
  describe ".parse" do
    subject { described_class.parse(uri) }

    context "schema is not amqp or amqps" do
      let(:uri) { "http://rabbitmq" }

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, /amqp or amqps schema/)
      end
    end

    context "path" do
      context "present" do
        let(:uri) { "amqp://rabbitmq/staging" }

        it "parses vhost" do
          expect(subject[:vhost]).to eq("staging")
        end

        context "with dots" do
          let(:uri) { "amqp://rabbitmq/staging.critical.subsystem-a" }

          it "parses vhost" do
            expect(subject[:vhost]).to eq("staging.critical.subsystem-a")
          end
        end

        context "with slashes" do
          let(:uri) { "amqp://rabbitmq/staging/critical/subsystem-a" }

          it "raises ArgumentError" do
            expect { subject[:vhost] }.to raise_error(ArgumentError)
          end
        end

        context "with trailing slash" do
          let(:uri) { "amqp://rabbitmq/" }

          it "parses vhost as an empty string" do
            expect(subject[:vhost]).to eq("")
          end
        end

        context "with trailing escaped slash" do
          let(:uri) { "amqp://rabbitmq/%2Fstaging" }

          it "parses vhost as string with leading slash" do
            expect(subject[:vhost]).to eq("/staging")
          end
        end
      end

      context "absent" do
        let(:uri) { "amqp://rabbitmq" }

        it "fallbacks to default nil vhost" do
          expect(subject[:vhost]).to be_nil
        end
      end
    end

    context "username and passowrd" do
      context "present" do
        let(:uri) { "amqp://alpha:beta@rabbitmq" }

        it "parses user and pass" do
          expect(subject[:user]).to eq("alpha")
          expect(subject[:pass]).to eq("beta")
        end
      end

      context "absent" do
        let(:uri) { "amqp://rabbitmq" }

        it "fallbacks to nil user and pass" do
          expect(subject[:user]).to be_nil
          expect(subject[:pass]).to be_nil
        end
      end
    end

    context "query parameters" do
      context "present" do
        let(:uri) { "amqp://rabbitmq?heartbeat=10&connection_timeout=100&channel_max=1000&auth_mechanism=plain&auth_mechanism=amqplain" }

        it "parses client connection parameters" do
          expect(subject[:heartbeat]).to eq(10)
          expect(subject[:connection_timeout]).to eq(100)
          expect(subject[:channel_max]).to eq(1000)
          expect(subject[:auth_mechanism]).to eq(["plain", "amqplain"])
        end
      end

      context "absent" do
        let(:uri) { "amqp://rabbitmq" }

        it "fallbacks to default client connection parameters" do
          expect(subject[:heartbeat]).to be_nil
          expect(subject[:connection_timeout]).to be_nil
          expect(subject[:channel_max]).to be_nil
          expect(subject[:auth_mechanism]).to be_empty
        end
      end

      context "schema amqp" do
        context "tls parameters" do
          %w(verify fail_if_no_peer_cert cacertfile certfile keyfile).each do |tls_param|
            describe "#{tls_param}" do
              let(:uri) { "amqp://rabbitmq?#{tls_param}=value" }

              it "raises ArgumentError" do
                expect { subject }.to raise_error(ArgumentError, /The option '#{tls_param}' can only be used in URIs that use amqps schema/)
              end
            end
          end
        end
      end

      context "schema amqps" do
        context "tls parameters" do
          context "present" do
            let(:uri) { "amqps://rabbitmq?verify=true&fail_if_no_peer_cert=true&cacertfile=/examples/tls/cacert.pem&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem" }

            it "parses tls options" do
              expect(subject[:verify]).to be_truthy
              expect(subject[:fail_if_no_peer_cert]).to be_truthy
              expect(subject[:cacertfile]).to eq("/examples/tls/cacert.pem")
              expect(subject[:certfile]).to eq("/examples/tls/client_cert.pem")
              expect(subject[:keyfile]).to eq("/examples/tls/client_key.pem")
            end
          end

          context "absent" do
          let(:uri) { "amqps://rabbitmq" }

          it "fallbacks to default tls options" do
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
  end
end
