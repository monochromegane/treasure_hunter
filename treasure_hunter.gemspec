# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'treasure_hunter/version'

Gem::Specification.new do |gem|
  gem.name          = "treasure_hunter"
  gem.version       = TreasureHunter::VERSION
  gem.authors       = ["monochromegane"]
  gem.email         = ["dev.kuro.obi@gmail.com"]
  gem.description   = %q{CLI to manage query of Treasure Data command line tool}
  gem.summary       = %q{CLI to manage query of Treasure Data command line tool}
  gem.homepage      = "https://github.com/monochromegane/treasure_hunter"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor"
  gem.add_dependency "git"
  gem.add_dependency "td"
  gem.add_development_dependency "rspec"
end
