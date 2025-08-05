# A sample Gemfile
source "https://rubygems.org"

gem 'falkorlib', git: 'https://github.com/Falkor/falkorlib.git', ref: 'ed25efb'

gem 'puppet-syntax', '< 6.0.0'

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 7'
  gem "pdk"
  gem "rspec", '< 3.2.0'
  gem "rspec-puppet"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop',   '~> 0.51'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'

  #gem 'puppet-lint',            '>= 0.3.2'
  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
  gem 'puppet-lint-resource_reference_syntax'
  gem 'semantic_puppet'

  gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'
end

group :system_tests do
  gem "beaker", '~> 6.1.0'
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
