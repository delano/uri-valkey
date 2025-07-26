# frozen_string_literal: true

require 'uri'
require 'uri/generic'
require_relative 'database_uri'

# URI::Redis - adds support for Redis URIs to core.
module URI
  # Redis URI
  #
  # This is a subclass of URI::Generic and supports the following URI formats:
  #
  #   redis://host:port/dbindex
  #
  # @example
  #   uri = URI::Redis.build(host: "localhost", port: 6379, db: 2, key: "v1:arbitrary:key")
  #   uri.to_s #=> "redis://localhost:6379/2/v1:arbitrary:key"
  #
  #   uri = URI::Redis.build(host: "localhost", port: 6379, db: 2)
  #   uri.to_s #=> "redis://localhost:6379/2"
  class Redis < URI::Generic
    include DatabaseURI

    private

    def ssl_schemes
      %w[rediss valkeys]
    end
  end

  if URI.respond_to?(:register_scheme)
    URI.register_scheme 'REDIS', Redis
    URI.register_scheme 'REDISS', Redis
    # Cross-scheme support for Valkey URLs
    URI.register_scheme 'VALKEY', Redis
    URI.register_scheme 'VALKEYS', Redis
  else
    @@schemes['REDIS'] = Redis
    @@schemes['REDISS'] = Redis
    # Cross-scheme support for Valkey URLs
    @@schemes['VALKEY'] = Redis
    @@schemes['VALKEYS'] = Redis
  end
end

if defined?(Redis)
  # Usage:
  # using RedisURIRefinement
  # redis = Redis.new
  # redis.uri
  module RedisURIRefinement
    refine Redis do
      def uri
        URI.parse @client.id
      end

      def self.uri(conf = {})
        URI.parse format('%s://%s:%s/%s', conf[:ssl] ? 'rediss' : 'redis', conf[:host], conf[:port], conf[:db])
      end
    end
  end
end
