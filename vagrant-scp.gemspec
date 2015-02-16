# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant/scp/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-scp"
  spec.version       = Vagrant::Scp::VERSION
  spec.authors       = ["Luca Invernizzi"]
  spec.email         = ["invernizzi.l@gmail.com"]
  spec.description   = 'Copy files to a Vagrant VM via SCP.'
  spec.summary       = 'Copy files to a Vagrant VM via SCP.'
  spec.homepage      = "https://github.com/invernizzi/vagrant-scp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_runtime_dependency 'log4r', "~> 1.1"
  spec.add_runtime_dependency 'net-scp', "~> 1.1"

end
