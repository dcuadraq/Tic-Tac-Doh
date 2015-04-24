# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tic_tac_doh/version'

Gem::Specification.new do |spec|
  spec.name          = "tic_tac_doh"
  spec.version       = TicTacDoh::VERSION
  spec.authors       = ["David Cuadra Quevedo"]
  spec.email         = ["dcuadraq@gmail.com"]

  spec.summary       = %q{Gem for playing Tic Tac Toe.}
  spec.description   = %q{Sizeable tic tac toe game.}
  spec.homepage      = "https://github.com/dcuadraq/tic_tac_doh"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
