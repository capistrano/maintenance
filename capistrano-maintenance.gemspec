# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-maintenance/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-maintenance"
  spec.version       = CapistranoMaintenance::VERSION
  spec.authors       = ["Kir Shatrov"]
  spec.email         = ["shatrov@me.com"]
  spec.description   = %q{Maintenance Support for Capistrano 3}
  spec.summary       = %q{Enable and disabled tasks to show when your project is on maintenance}
  spec.homepage      = "https://github.com/capistrano/capistrano-maintenance"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
