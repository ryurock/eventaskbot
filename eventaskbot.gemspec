# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventaskbot/version'

Gem::Specification.new do |spec|
  spec.name          = "eventaskbot"
  spec.version       = Eventaskbot::VERSION
  spec.authors       = ["TODO: Write your name"]
  spec.email         = ["ryusukekimura3@gmail.com"]
  spec.description   = %q{[eventmachine](https://github.com/eventmachine/eventmachine) using to task notify Service}
  spec.summary       = %q{[eventmachine](https://github.com/eventmachine/eventmachine) using to task notify Service}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "eventmachine"
  spec.add_development_dependency "whenever"
  spec.add_development_dependency "multi_json"
  spec.add_development_dependency "term-ansicolor"
  spec.add_development_dependency "mechanize"
  spec.add_development_dependency "yammer"
end
