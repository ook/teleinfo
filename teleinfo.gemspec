# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teleinfo/version'

Gem::Specification.new do |spec|
  spec.name          = "teleinfo"
  spec.version       = Teleinfo::VERSION
  spec.authors       = ["Thomas Lecavelier"]
  spec.email         = ["thomas@followanalytics.com"]
  spec.summary       = %q{Parse data from french electric meter Téléinfo (from EDF).}
  spec.description   = %q{Parse data from french electric meter Téléinfo (from EDF). Deal with file or STDIN (anything responding to #readline, so NOT Pathname.)}
  spec.homepage      = "https://github.com/ook/teleinfo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['teleinfo']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", '~> 0.28'
  spec.add_development_dependency "guard-rspec", '~> 4.3'
end
