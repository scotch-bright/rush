# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rush/version'

Gem::Specification.new do |spec|
  spec.name          = "rush"
  spec.version       = Rush::VERSION
  spec.authors       = ["Khoj Badami"]
  spec.email         = ["khoj.badami@gmail.com"]

  spec.summary       = %q{Rush: The fastest way to make a static website.}
  spec.description   = %q{Rush: The fastest way to make a static website.}
  spec.homepage      = "http://google.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'sass', '~> 3.4'
  spec.add_runtime_dependency 'uglifier', '~> 3.0'
  spec.add_runtime_dependency 'coffee-script', '~> 2.3'
end
