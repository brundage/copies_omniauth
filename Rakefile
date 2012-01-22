require "bundler/gem_tasks"
require 'rake'
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/specs/*_spec.rb"
end

