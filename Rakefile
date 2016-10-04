require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new do |doc|
  doc.main   = 'README.md'
  doc.title  = 'Quke'
  doc.rdoc_files = FileList.new %w[README.md lib LICENSE]
end

task :default => :spec
