#!/usr/bin/env rake

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rspec/core/rake_task'

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

begin

  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
rescue LoadError
end