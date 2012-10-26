require 'rubygems'
require 'simplecov'
require 'bundler'
require 'rspec/core'
require 'rspec/expectations'
require 'rspec/mocks'

#Bundler.require(:all) if defined? Bundler

SimpleCov.start

RSpec.configure do |config|
  config.mock_with :mocha
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true
end


