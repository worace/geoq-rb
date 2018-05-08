# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','geo-cli','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'geo-cli'
  s.version = GeoCli::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','geo-cli.rdoc']
  s.rdoc_options << '--title' << 'geo-cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'geo-cli'

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency "minitest", "~> 5.11"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "pry"

  s.add_runtime_dependency('gli','2.17.1')
  s.add_runtime_dependency('rgeo')
  s.add_runtime_dependency('rgeo-geojson')
  s.add_runtime_dependency('pr_geohash', '~>1.0')
end