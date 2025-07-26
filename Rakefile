# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'


RuboCop::RakeTask.new

# Set up RSpec for both gems
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new('spec:redis') do |spec|
  spec.pattern = 'spec/uri-redis/*_spec.rb'
end

RSpec::Core::RakeTask.new('spec:valkey') do |spec|
  spec.pattern = 'spec/uri-valkey/*_spec.rb'
end

require 'rdoc/task'
RDoc::Task.new do |doc|
  doc.main   = 'README.md'
  doc.title  = 'URI::Redis and URI::Valkey - handle Uniform Resource Identifier parsing for Redis and Valkey'
  doc.rdoc_files = FileList.new %w[lib README.md LICENSE.txt]
  doc.rdoc_dir = '_site' # for github pages
end

# Multi-gem build tasks
namespace :build do
  desc 'Build uri-redis gem'
  task :redis do
    Dir.chdir('gems') do
      sh 'gem build uri-redis.gemspec'
      sh 'mv uri-redis-*.gem ../pkg/'
    end
  end

  desc 'Build uri-valkey gem'
  task :valkey do
    Dir.chdir('gems') do
      sh 'gem build uri-valkey.gemspec'
      sh 'mv uri-valkey-*.gem ../pkg/'
    end
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
