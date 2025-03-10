lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trailblazer/endpoint/version'

Gem::Specification.new do |spec|
  spec.name          = "trailblazer-endpoint"
  spec.version       = Trailblazer::Endpoint::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]
  spec.description   = %q{Generic HTTP handlers for operation results.}
  spec.summary       = %q{Generic HTTP handlers for operation results.}
  spec.homepage      = "http://trailblazer.to/gems/operation/endpoint.html"
  spec.license       = "LGPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "dry-matcher", ">= 0.8.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "trailblazer", ">= 2.1.0.rc13"
end
