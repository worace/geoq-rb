# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','geoq','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'geoq'
  s.version = Geoq::VERSION
  s.author = 'Horace Williams'
  s.email = 'horace@worace.works'
  s.homepage = 'https://github.com/worace/geoq'
  s.platform = Gem::Platform::RUBY
  s.license = 'MIT'
  s.summary = 'geoq is a command-line utility for GIS format conversion and common GIS operations'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'geoq'

  s.add_development_dependency('rake', '~>12.3')
  s.add_development_dependency('aruba', '~>0.14')
  s.add_development_dependency('minitest', '~> 5.11')
  s.add_development_dependency('minitest-reporters', '~>1.2')
  s.add_development_dependency('pry', '~>0.11')

  s.add_runtime_dependency('gli','~>2.17')
  s.add_runtime_dependency('rgeo', '~>1.0')
  s.add_runtime_dependency('rgeo-geojson', '~>2.0')
  s.add_runtime_dependency('pr_geohash', '~>1.0')
end
