require "rdoc/task"
require "minitest/test_task"

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

Minitest::TestTask.create

begin
  require "rubygems/tasks"
  Gem::Tasks.new
rescue LoadError
end

task default: :test
