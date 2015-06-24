# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vstool/version'

Gem::Specification.new do |spec|
  spec.name          = "vstool"
  spec.version       = Vstool::VERSION
  spec.authors       = ["Yusuke Yachi"]
  spec.email         = ["yyachi@misasa.okayama-u.ac.jp"]
  spec.summary       = %q{Tools for VisualStage and OpenCV.}
  spec.description   = %q{Command line utilities for VisualStage and OpenCV.}
  spec.homepage      = "http://dream.misasa.okayama-u.ac.jp/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "turnip", "~> 1.2"

  spec.add_dependency "bindata", "~>2.1"
  spec.add_dependency "dimensions", "~>1.3"
  spec.add_dependency "yajl-ruby"
  spec.add_dependency "visual_stage"
  spec.add_dependency "opencvtool"
end
