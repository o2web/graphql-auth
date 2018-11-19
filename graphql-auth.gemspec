# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'graphql-auth'
  spec.version       = '0.1.3'
  spec.authors       = ['Guillaume Ferland']
  spec.email         = ['ferland182@gmail.com']
  spec.platform    = Gem::Platform::RUBY
  spec.summary       = %q{GraphQL + JWT + Devise}
  spec.description   = %q{GraphQL + JWT + Devise}
  spec.homepage      = 'https://github.com/o2web/graphql-auth'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.files	      = Dir['README.md', 'Gemfile', '{app,lib,vendor}/**/*']
  spec.require_paths = %w(app lib)

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'graphql', '~> 1.8'
  spec.add_dependency 'devise', '~> 4.4'
  spec.add_dependency 'jwt', '~> 1.5'
end
