# frozen_string_literal: true

require 'uri'
require 'uri/generic'
require_relative 'database_uri'

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
    include DatabaseURI

    private

    def ssl_schemes
      %w[valkeys rediss]
    end
  end

  if URI.respond_to?(:register_scheme)
    URI.register_scheme 'VALKEY', Valkey
    URI.register_scheme 'VALKEYS', Valkey
    # Cross-scheme support for Redis URLs
    URI.register_scheme 'REDIS', Valkey
    URI.register_scheme 'REDISS', Valkey
  else
    @@schemes['VALKEY'] = Valkey
    @@schemes['VALKEYS'] = Valkey
    # Cross-scheme support for Redis URLs
    @@schemes['REDIS'] = Valkey
    @@schemes['REDISS'] = Valkey
  end
end
