# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','geo-cli','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'geo-cli'
  s.version = GeoCli::VERSION
  s.author = 'Horace Williams'
  s.email = 'horace@worace.works'
  s.homepage = 'https://github.com/worace/geo-cli'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'
  s.summary = 'geo-cli is a command-line utility for converting between common GIS serialization formats.'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','geo-cli.rdoc']
  s.rdoc_options << '--title' << 'geo-cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'geo-cli'

  s.add_development_dependency('rake', '~>12.3')
  s.add_development_dependency('rdoc', '~>6.0')
  s.add_development_dependency('aruba', '~>0.14')
  s.add_development_dependency('minitest', '~> 5.11')
  s.add_development_dependency('minitest-reporters', '~>1.2')
  s.add_development_dependency('pry', '~>0.11')

  s.add_runtime_dependency('gli','~>2.17')
  s.add_runtime_dependency('rgeo', '~>1.0')
  s.add_runtime_dependency('rgeo-geojson', '~>2.0')
  s.add_runtime_dependency('pr_geohash', '~>1.0')
end
