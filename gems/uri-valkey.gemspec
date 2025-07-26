# frozen_string_literal: true

require_relative '../lib/uri_valkey/version'

Gem::Specification.new do |spec|
  spec.name = 'uri-valkey'
  spec.version = URI::Valkey::VERSION
  spec.authors = ['delano']
  spec.email = ['gems@solutious.com']

  spec.summary = 'URI-Valkey: support for parsing Valkey URIs'
  spec.description = 'URI-Valkey: support for parsing Valkey URIs like valkey://host:port/dbindex/key'
  spec.homepage = 'https://github.com/delano/uri-valkey'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.5'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/delano/uri-valkey/'
  spec.metadata['changelog_uri'] = 'https://github.com/delano/uri-valkey/blob/main/CHANGES.txt#L1'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.dirname(__dir__)) do
    [
      'lib/uri/valkey.rb',
      'lib/uri/valkey/version.rb',
      'lib/uri-valkey.rb',
      'lib/uri_valkey.rb'
    ] + ['README.md', 'LICENSE.txt', 'CHANGES.txt'].select { |f| File.exist?(f) }
  end
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
