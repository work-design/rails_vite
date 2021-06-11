require_relative 'lib/viter/version'

Gem::Specification.new do |spec|
  spec.name = 'viter'
  spec.version = Viter::VERSION
  spec.authors = ['qinmingyuan']
  spec.email = ['mingyuan0715@foxmail.com']
  spec.homepage = 'https://github.com/qinmingyuan/viter'
  spec.summary = 'Vite for Rails'
  spec.description = 'Description of Viter.'
  spec.license = 'MIT'

  spec.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'rails'
end
