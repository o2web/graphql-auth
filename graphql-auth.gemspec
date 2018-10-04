# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'graphql-auth'
  spec.version       = '0.1.0'
  spec.authors       = ['Guillaume Ferland']
  spec.email         = ['ferland182@gmail.com']
  spec.platform    = Gem::Platform::RUBY
  spec.summary       = %q{GraphQL + JWT + Devise}
  spec.description   = %q{GraphQL + JWT + Devise}
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files	      = Dir['README.md', 'Gemfile', '{app,lib,vendor}/**/*']
  spec.require_paths = %w(app lib)

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'graphql', '~> 1.8.5'
  spec.add_dependency 'devise', '~> 4.4.3'
  spec.add_dependency 'jwt', '~> 1.5.6'
end
