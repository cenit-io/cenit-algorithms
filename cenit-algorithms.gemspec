# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cenit/algorithms/version'

Gem::Specification.new do |spec|
  spec.name          = 'cenit-algorithms'
  spec.version       = Cenit::Algorithms::VERSION
  spec.authors       = ['Maikel Arcia']
  spec.email         = ['macarci@gmail.com']

  spec.summary       = %q{Runs Cenit algorithms.}
  spec.description   = %q{Run algorithms retrieving their codes from Cenit.}
  spec.homepage      = 'https://github.com/cenit-io/cenit-algorithms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'cenit-config', '~> 0.0.1'
  spec.add_runtime_dependency 'httparty', '~> 0.13.7'
  spec.add_runtime_dependency 'json', '~> 1.8.3', '>= 1.8.3'
  spec.add_runtime_dependency 'parser', '~> 2.3.1.4', '>= 2.3.1.4'
end
