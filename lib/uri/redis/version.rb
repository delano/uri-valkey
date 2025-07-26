# frozen_string_literal: true

require 'uri/generic'

module URI
  class Redis < URI::Generic
    VERSION = '1.3.0'
    SUMMARY = 'A Ruby library for parsing, building and normalizing redis URLs'
  end
end
