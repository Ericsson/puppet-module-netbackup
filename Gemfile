source ENV['GEM_SOURCE'] || 'https://rubygems.org'

if ENV['PUPPET_GEM_VERSION']
  gem 'puppet', ENV['PUPPET_GEM_VERSION'], :require => false
else
  gem 'puppet', :require => false
end

gem 'facter', '>= 1.7.0', :require => false
gem 'rspec-puppet', :require => false
gem 'puppet-lint', '~> 2.0', :require => false
gem 'puppet-lint-absolute_classname-check', :require => false
gem 'puppet-lint-alias-check', :require => false
gem 'puppet-lint-empty_string-check', :require => false
gem 'puppet-lint-file_ensure-check', :require => false
gem 'puppet-lint-file_source_rights-check', :require => false
gem 'puppet-lint-leading_zero-check', :require => false
gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
gem 'puppet-lint-trailing_comma-check', :require => false
gem 'puppet-lint-undef_in_function-check', :require => false
gem 'puppet-lint-unquoted_string-check', :require => false
gem 'puppet-lint-variable_contains_upcase', :require => false

gem 'rspec',              '~> 2.0',   :require => false if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'rake',               '~> 10.0',  :require => false if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'json',               '<= 1.8',   :require => false if RUBY_VERSION < '2.0.0'
gem 'json_pure',          '<= 2.0.1', :require => false if RUBY_VERSION < '2.0.0'
gem 'metadata-json-lint', '0.0.11',   :require => false if RUBY_VERSION < '1.9'
gem 'metadata-json-lint',             :require => false if RUBY_VERSION >= '1.9'

# Puppetlabs is dropping support for Ruby 1.8.7 in latests releases, pin to last supported version when running on Ruby 1.8.7
gem 'puppetlabs_spec_helper', '2.0.2',    :require => false if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'puppetlabs_spec_helper', '>= 2.0.0', :require => false if RUBY_VERSION >= '1.9'
gem 'parallel_tests',         '<= 2.9.0', :require => false if RUBY_VERSION < '2.0.0'
