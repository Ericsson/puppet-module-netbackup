source 'https://rubygems.org'

if ENV['PUPPET_GEM_VERSION']
  gem 'puppet', ENV['PUPPET_GEM_VERSION'], :require => false
else
  gem 'puppet', :require => false
end

gem 'metadata-json-lint'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'

if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
  # rspec must be v2 for ruby 1.8.7
  gem 'rspec', '~> 2.0'
  # rake >= 11 does not support ruby 1.8.7
  gem 'rake', '~> 10.0'
end
