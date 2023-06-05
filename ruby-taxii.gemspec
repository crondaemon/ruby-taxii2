# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxii/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-taxii2'
  spec.version       = Taxii::VERSION
  spec.authors       = ['Dario Lombardo']
  spec.email         = ['lomato@gmail.com']
  spec.license       = 'GPL-2.0-or-later'

  spec.summary       = %q{ ruby taxii client }
  spec.description   = %q{ implement api-alike for python libtaxii https://github.com/TAXIIProject/libtaxii }
  spec.homepage      = 'https://github.com/crondaemon/ruby-taxii2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.15.2'
  spec.add_dependency 'nori', '~> 2.6.0'
  spec.add_dependency 'gyoku', '~> 1.4.0'
  spec.add_dependency 'hashie', '~> 5.0.0'
  spec.add_dependency 'rest-client', '~> 2.1.0'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
  spec.add_development_dependency 'guard', '~> 2.18.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'guard-bundler', '~> 3.0.1'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'vcr', '~> 6.1.0'
  spec.add_development_dependency 'webmock', '~> 3.18.1'
  spec.add_development_dependency 'pry', '~> 0.13.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.10.1'
end
