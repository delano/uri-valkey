# frozen_string_literal: true

require_relative '../lib/uri/redis'

RSpec.describe 'URI::Redis' do
  before(:all) do
    require 'uri/redis'
  end

  it 'Default database is 0' do
    result = begin
      uri = URI.parse 'redis://localhost'
      [uri.db, uri.host, uri.port]
    end
    expect(result).to eq([0, 'localhost', 6379])
  end

  it 'Can parse a redis URI with a database' do
    result = begin
      uri = URI.parse 'redis://localhost/2'
      [uri.db, uri.host, uri.port]
    end
    expect(result).to eq([2, 'localhost', 6379])
  end

  it 'Parsed URI can be accessed via conf hash' do
    result = begin
      uri = URI.parse 'redis://localhost:6379/2'
      [uri.scheme, uri.conf]
    end
    expect(result).to eq(['redis', { host: 'localhost', port: 6379, db: 2, ssl: false }])
  end

  it 'Can parse a key name' do
    result = begin
      uri = URI.parse 'redis://localhost/2/v1:arbitrary:key'
      [uri.key, uri.db, uri.host, uri.port]
    end
    expect(result).to eq(['v1:arbitrary:key', 2, 'localhost', 6379])
  end

  it 'Can set db' do
    result = begin
      uri = URI.parse 'redis://localhost/2/v1:arbitrary:key'
      uri.db = 6
      uri.to_s
    end
    expect(result).to eq('redis://localhost/6/v1:arbitrary:key')
  end

  it 'Can set key' do
    result = begin
      uri = URI.parse 'redis://localhost/2/v1:arbitrary:key'
      uri.key = 'v2:arbitrary:key'
      uri.to_s
    end
    expect(result).to eq('redis://localhost/2/v2:arbitrary:key')
  end

  it 'Support rediss' do
    result = begin
      uri = URI.parse 'rediss://localhost'
      [uri.scheme, uri.conf]
    end
    expect(result).to eq(['rediss', { host: 'localhost', port: 6379, db: 0, ssl: true }])
  end
end
