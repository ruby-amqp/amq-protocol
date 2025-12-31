require "amq/settings"

RSpec.describe AMQ::Settings do
  describe ".default" do
    it "should provide some default values" do
      expect(AMQ::Settings.default).to_not be_nil
      expect(AMQ::Settings.default[:host]).to_not be_nil
    end

    it "includes default port" do
      expect(AMQ::Settings.default[:port]).to eq(5672)
    end

    it "includes default credentials" do
      expect(AMQ::Settings.default[:user]).to eq("guest")
      expect(AMQ::Settings.default[:pass]).to eq("guest")
    end
  end

  describe ".configure" do
    it "should merge custom settings with default settings" do
      settings = AMQ::Settings.configure(:host => "tagadab")
      expect(settings[:host]).to eql("tagadab")
    end

    it "should merge custom settings from AMQP URL with default settings" do
      settings = AMQ::Settings.configure("amqp://tagadab")
      expect(settings[:host]).to eql("tagadab")
    end

    it "returns default when passed nil" do
      settings = AMQ::Settings.configure(nil)
      expect(settings).to eq(AMQ::Settings.default)
    end

    it "normalizes username to user" do
      settings = AMQ::Settings.configure(:username => "admin")
      expect(settings[:user]).to eq("admin")
    end

    it "normalizes password to pass" do
      settings = AMQ::Settings.configure(:password => "secret")
      expect(settings[:pass]).to eq("secret")
    end

    it "prefers user over username when both provided" do
      settings = AMQ::Settings.configure(:user => "admin", :username => "other")
      expect(settings[:user]).to eq("admin")
    end
  end

  describe ".parse_amqp_url" do
    it "delegates to AMQ::URI.parse" do
      result = AMQ::Settings.parse_amqp_url("amqp://localhost")
      expect(result[:host]).to eq("localhost")
    end
  end
end
