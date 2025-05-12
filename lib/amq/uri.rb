# encoding: utf-8

if RUBY_VERSION < "3.5"
  require "cgi/util"
else
  require "cgi/escape"
end
require "uri"

module AMQ
  class URI
    # @private
    AMQP_DEFAULT_PORTS = {
      "amqp" => 5672,
      "amqps" => 5671
    }.freeze

    private_constant :AMQP_DEFAULT_PORTS

    DEFAULTS = {
      heartbeat: nil,
      connection_timeout: nil,
      channel_max: nil,
      auth_mechanism: [],
      verify: false,
      fail_if_no_peer_cert: false,
      cacertfile: nil,
      certfile: nil,
      keyfile: nil
    }.freeze

    def self.parse(connection_string)
      uri = ::URI.parse(connection_string)
      raise ArgumentError.new("Connection URI must use amqp or amqps schema (example: amqp://bus.megacorp.internal:5766), learn more at http://bit.ly/ks8MXK") unless %w{amqp amqps}.include?(uri.scheme)

      opts = DEFAULTS.dup

      opts[:scheme] = uri.scheme
      opts[:user]   = ::CGI::unescape(uri.user) if uri.user
      opts[:pass]   = ::CGI::unescape(uri.password) if uri.password
      opts[:host]   = uri.host if uri.host and uri.host != ""
      opts[:port]   = uri.port || AMQP_DEFAULT_PORTS[uri.scheme]
      opts[:ssl]    = uri.scheme.to_s.downcase =~ /amqps/i # TODO: rename to tls
      if uri.path =~ %r{^/(.*)}
        raise ArgumentError.new("#{uri} has multiple-segment path; please percent-encode any slashes in the vhost name (e.g. /production => %2Fproduction). Learn more at http://bit.ly/amqp-gem-and-connection-uris") if $1.index('/')
        opts[:vhost] = ::CGI::unescape($1)
      end

      if uri.query
        query_params = Hash.new { |hash, key| hash[key] = [] }
        ::URI.decode_www_form(uri.query).each do |key, value|
          query_params[key] << value
        end
        query_params.each do |key, value|
          query_params[key] = value.one? ? value.first : value
        end
        query_params.default = nil

        opts[:heartbeat] = query_params["heartbeat"].to_i
        opts[:connection_timeout] = query_params["connection_timeout"].to_i
        opts[:channel_max] = query_params["channel_max"].to_i
        opts[:auth_mechanism] = query_params["auth_mechanism"]

        %w(cacertfile certfile keyfile).each do |tls_option|
          if query_params[tls_option] && uri.scheme == "amqp"
            raise ArgumentError.new("The option '#{tls_option}' can only be used in URIs that use amqps schema")
          else
            opts[tls_option.to_sym] = query_params[tls_option]
          end
        end

        %w(verify fail_if_no_peer_cert).each do |tls_option|
          if query_params[tls_option] && uri.scheme == "amqp"
            raise ArgumentError.new("The option '#{tls_option}' can only be used in URIs that use amqps schema")
          else
            opts[tls_option.to_sym] = as_boolean(query_params[tls_option])
          end
        end
      end

      opts
    end

    def self.parse_amqp_url(s)
      parse(s)
    end

    #
    # Implementation
    #

    # Normalizes values returned by URI.decode_www_form.
    # @private
    def self.as_boolean(val)
      case val
      when true    then true
      when false   then false
      when 1       then true
      when 0       then false
      when "true"  then true
      when "false" then false
      else
        !!val
      end
    end

    private_class_method :as_boolean
  end
end
