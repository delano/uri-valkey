# frozen_string_literal: true

require 'uri'
require 'uri/generic'

module URI
  class Valkey < URI::Generic
    VERSION = '1.4.0'
    SUMMARY = 'A Ruby library for parsing, building and normalizing valkey URLs'
  end
end
