# -*- coding: utf-8 -*-
require "rake/testtask"
require "yard"
require "yard/rake/yardoc_task"
require "rubocop/rake_task"

task default: [:test, :rubocop, :yard]

SOURCE_FILES = FileList.new("./lib/**/*.rb", "./app/**/*.rb")

desc "test/unit"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test_*.rb"]
  t.verbose = true
end

desc "Run RuboCop on the lib directory"
RuboCop::RakeTask.new(:rubocop) do |t|
  t.patterns = ["lib/**/*.rb", "app/**/*.rb", "test/**/*.rb"]
end

desc "make yard"
YARD::Rake::YardocTask.new do |t|
  t.files = SOURCE_FILES
  t.options = %w(--debug --verbose) if Rake.application.options.trace
end
