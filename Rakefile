require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'github_changelog_generator/task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new do |doc|
  doc.main   = 'README.md'
  doc.title  = 'Quke'
  doc.rdoc_files = FileList.new %w[README.md lib LICENSE]
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
end
