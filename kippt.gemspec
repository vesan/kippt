# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kippt/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vesa Vänskä"]
  gem.email         = ["vesa@vesavanska.com"]
  gem.description   = %q{Client library for using Kippt.com API}
  gem.summary       = %q{Client library for using Kippt.com API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "kippt"
  gem.require_paths = ["lib"]
  gem.version       = Kippt::VERSION

  gem.add_dependency "faraday", "~> 0.7.6"
  gem.add_dependency "faraday_middleware", "~> 0.8.7"
  gem.add_dependency "multi_json", "~> 1.3.4"

  gem.add_development_dependency "rspec", "~> 2.9.0"
  gem.add_development_dependency "webmock", "~> 1.8.6"
end
