# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxii/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-taxii'
  spec.version       = Taxii::VERSION
  spec.authors       = ['Ryan Breed']
  spec.email         = ['opensource@breed.org']

  spec.summary       = %q{ ruby taxii client }
  spec.description   = %q{ implement api-alike for python libtaxii https://github.com/TAXIIProject/libtaxii }
  spec.homepage      = 'https://github.com/ryanbreed/ruby-taxii'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'libxml-ruby'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'nori'
  spec.add_dependency 'gyoku'
  spec.add_dependency 'hashie'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
