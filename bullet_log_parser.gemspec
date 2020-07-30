# frozen_string_literal: true

require_relative 'lib/bullet_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'bullet_log_parser'
  spec.version       = BulletLogParser::VERSION
  spec.authors       = ['satoruk']
  spec.email         = ['koyanagi3106@gmail.com']

  spec.summary       = 'Bullet log perser.'
  spec.description   = 'Bullet log perser.'
  spec.homepage      = 'https://github.com/satoruk/bullet_log_parser/'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  spec.files = %w[CHANGELOG.md LICENSE.txt README.md bullet_log_parser.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')

  spec.require_paths = ['lib']
end
