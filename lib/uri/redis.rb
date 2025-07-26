# frozen_string_literal: true

require 'uri'
require 'uri/generic'

require_relative 'perfect_strangers'

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
    include PerfectStrangers

    private

    def ssl_schemes
      %w[rediss valkeys]
    end
  end

  if URI.respond_to?(:register_scheme)
    URI.register_scheme 'REDIS', Redis unless URI.scheme_list.key?('REDIS')
    URI.register_scheme 'REDISS', Redis unless URI.scheme_list.key?('REDISS')
    # Cross-scheme support for Valkey URLs
    URI.register_scheme 'VALKEY', Redis unless URI.scheme_list.key?('VALKEY')
    URI.register_scheme 'VALKEYS', Redis unless URI.scheme_list.key?('VALKEYS')
  else
    @@schemes['REDIS'] = Redis unless @@schemes.key?('REDIS')
    @@schemes['REDISS'] = Redis unless @@schemes.key?('REDISS')
    # Cross-scheme support for Valkey URLs
    @@schemes['VALKEY'] = Redis unless @@schemes.key?('VALKEY')
    @@schemes['VALKEYS'] = Redis unless @@schemes.key?('VALKEYS')
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
