# frozen_string_literal: true

require_relative '../lib/uri_redis/version'

Gem::Specification.new do |spec|
  spec.name = 'uri-redis'
  spec.version = URI::Redis::VERSION
  spec.authors = ['delano']
  spec.email = ['gems@solutious.com']

  spec.summary = 'URI-Redis: support for parsing Redis URIs'
  spec.description = 'URI-Redis: support for parsing Redis URIs like redis://host:port/dbindex/key'
  spec.homepage = 'https://github.com/delano/uri-redis'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.5'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/delano/uri-redis/'
  spec.metadata['changelog_uri'] = 'https://github.com/delano/uri-redis/blob/feature/001-modernize/CHANGES.txt#L1'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.dirname(__dir__)) do
    [
      'lib/uri/redis.rb',
      'lib/uri/redis/version.rb',
      'lib/uri/perfect_strangers.rb',
      'lib/uri-redis.rb',
      'lib/uri_redis.rb'
    ] + ['README.md', 'LICENSE.txt', 'CHANGES.txt'].select { |f| File.exist?(f) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
