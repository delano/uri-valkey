# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new

# Set up RSpec for both gems
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new('spec:redis') do |spec|
  spec.pattern = 'spec/uri/redis_spec.rb'
end

RSpec::Core::RakeTask.new('spec:valkey') do |spec|
  spec.pattern = 'spec/uri/valkey_spec.rb'
end

require 'rdoc/task'
RDoc::Task.new do |doc|
  doc.main   = 'README.md'
  doc.title  = 'URI::Valkey and URI::Redis - handle Uniform Resource Identifier parsing for Valkey and Redis'
  doc.rdoc_files = FileList.new %w[lib README.md LICENSE.txt]
  doc.rdoc_dir = '_site' # for github pages
end

# Multi-gem build tasks
namespace :build do
  desc 'Build uri-redis gem'
  task :redis do
    sh 'gem build gems/uri-redis.gemspec'
    sh 'mv uri-redis-*.gem pkg/'
  end

  desc 'Build uri-valkey gem'
  task :valkey do
    sh 'gem build gems/uri-valkey.gemspec'
    sh 'mv uri-valkey-*.gem pkg/'
  end

  desc 'Build both gems'
  task all: %i[redis valkey]
end

# Multi-gem install tasks
namespace :install do
  desc 'Install uri-redis gem locally'
  task redis: 'build:redis' do
    sh 'gem install pkg/uri-redis-*.gem'
  end

  desc 'Install uri-valkey gem locally'
  task valkey: 'build:valkey' do
    sh 'gem install pkg/uri-valkey-*.gem'
  end

  desc 'Install both gems locally'
  task all: %i[redis valkey]
end

task default: :rubocop
