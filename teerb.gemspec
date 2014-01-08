# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teerb/version'

Gem::Specification.new do |spec|
  spec.name          = "teerb"
  spec.version       = TeeRb::VERSION
  spec.authors       = ["Patrick Huesler"]
  spec.email         = ["patrick.huesler@gmail.com"]
  spec.summary       = "Ruby Tee Utils"
  spec.description   = "Several ways to capture and tee Ruby's standard input and output"
  spec.homepage      = "https://https://github.com/phuesler/teerb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
end
