# frozen_string_literal: true

require 'uri'
require 'uri/generic'

require_relative 'perfect_strangers'

# URI::Valkey - adds support for Valkey URIs to core.
module URI
  # Valkey URI
  #
  # This is a subclass of URI::Generic and supports the following URI formats:
  #
  #   valkey://host:port/dbindex
  #
  # @example
  #   uri = URI::Valkey.build(host: "localhost", port: 6379, db: 2, key: "v1:arbitrary:key")
  #   uri.to_s #=> "valkey://localhost:6379/2/v1:arbitrary:key"
  #
  #   uri = URI::Valkey.build(host: "localhost", port: 6379, db: 2)
  #   uri.to_s #=> "valkey://localhost:6379/2"
  class Valkey < URI::Generic
    include PerfectStrangers

    private

    def ssl_schemes
      %w[valkeys rediss]
    end
  end

  if URI.respond_to?(:register_scheme)
    URI.register_scheme 'VALKEY', Valkey unless URI.scheme_list.key?('VALKEY')
    URI.register_scheme 'VALKEYS', Valkey unless URI.scheme_list.key?('VALKEYS')
    # Cross-scheme support for Redis URLs
    URI.register_scheme 'REDIS', Valkey unless URI.scheme_list.key?('REDIS')
    URI.register_scheme 'REDISS', Valkey unless URI.scheme_list.key?('REDISS')
  else
    @@schemes['VALKEY'] = Valkey unless @@schemes.key?('VALKEY')
    @@schemes['VALKEYS'] = Valkey unless @@schemes.key?('VALKEYS')
    # Cross-scheme support for Redis URLs
    @@schemes['REDIS'] = Valkey unless @@schemes.key?('REDIS')
    @@schemes['REDISS'] = Valkey unless @@schemes.key?('REDISS')
  end
end
