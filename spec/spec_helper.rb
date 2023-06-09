$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
require 'vcr'

VCR.configure do |v|
  v.cassette_library_dir = 'spec/fixtures/cassettes'
  v.hook_into :webmock
end

require 'taxii'
