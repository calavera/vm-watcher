# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["David Calavera"]
  gem.email         = ["david.calavera@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vm-watcher"
  gem.require_paths = ["lib"]
  gem.version       = '0.1.0'

  gem.add_runtime_dependency('vagrant')
end
