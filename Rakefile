require 'rubygems'
require 'rdoc/task'
require 'yard'
require 'rspec/core/rake_task'
require "bundler"
Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--colour', '--format progress']
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/restfulie/**/*.rb', 'README.textile']
end

Rake::RDocTask.new("rdoc") do |rdoc|
   rdoc.options << '--line-numbers' << '--inline-source'
end

desc "Runs everything"
task :all => ["install", "test:spec"]

desc "Default build will run specs"
task :default => :spec
