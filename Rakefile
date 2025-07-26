# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

require 'rdoc/task'
RDoc::Task.new do |doc|
  doc.main   = 'README.md'
  doc.title  = 'URI::Valkey - handle Uniform Resource Identifier parsing for Valkey'
  doc.rdoc_files = FileList.new %w[lib README.md LICENSE.txt]
  doc.rdoc_dir = '_site' # for github pages
end

task default: :rubocop
