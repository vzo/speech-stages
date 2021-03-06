# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speech/stages/version'

Gem::Specification.new do |spec|
  spec.name          = "speech-stages"
  spec.version       = Speech::Stages::VERSION
  spec.authors       = ["Juergen Fesslmeier"]
  spec.email         = ["jfesslmeier@gmail.com"]
  spec.summary       = %q{Application specific common helper library to sync chunk processing stages.}
  spec.description   = %q{Application specific common helper library to sync chunk processing stages.}
  spec.homepage      = "https://github.com/vzo/speech-stages"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "byebug", "~> 9.0"
end
