# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed/plugins/mutex/version'

Gem::Specification.new do |gem|
  gem.name          = "delayed-plugins-mutex"
  gem.version       = Delayed::Plugins::Mutex::VERSION
  gem.authors       = ['Jan Bromberger']
  gem.email         = ['jan.bromberger+delayed-plugins-mutex@gmail.com']
  gem.description   = %q(delayed_job plugin for mutual exclusion)
  gem.summary       = %q(Define, how many jobs of a certain kind can be enqueued or run at the same time.)
  gem.homepage      = ""

  gem.license       = "MIT"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies are not using versions so that there are few version conflicts for users.
  gem.add_dependency("activerecord", [">= 3.0", "< 5.0"])
  gem.add_dependency('delayed_job')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
end