require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
# Disabled because puppet-lint incorrectly warns about double-quoted strings with facts
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Run puppet in noop mode and check for syntax errors."
task :validate do
   Dir['manifests/**/*.pp'].each do |path|
     sh "puppet parser validate --noop #{path}"
   end
end
