# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reactive_record/version'

Gem::Specification.new do |gem|
  gem.name          = "reactive_record"
  gem.version       = ReactiveRecord::VERSION
  gem.authors       = ["Joe Nelson", "Chris Wilson"]
  gem.email         = ["christopher.j.wilson@gmail.com"]
  gem.description   = %q{Generate ActiveRecord models from a pre-existing Postgres db}
  gem.summary       = %q{Use the schema you always wanted.}
  gem.homepage      = "https://github.com/twopoint718/reactive_record"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "pg"
  gem.add_dependency "activesupport"

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rexical'
  gem.add_development_dependency 'racc'
  gem.add_development_dependency 'pry'
end
