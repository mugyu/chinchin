require 'rake/testtask'
require 'yard'
require 'yard/rake/yardoc_task'

task :default => [:test, :yard]

SOURCE_FILES = FileList.new('./lib/**/*.rb')

desc "test/unit"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test_*.rb"]
  t.verbose = true
end

desc "make yard"
YARD::Rake::YardocTask.new do |t|
  t.files = SOURCE_FILES
  t.options = ['--debug', '--verbose'] if $trace
end
