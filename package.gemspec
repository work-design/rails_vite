Gem::Specification.new do |s|
  s.name = 'rails_vite'
  s.version = '0.0.1'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_vite'
  s.summary = 'Vite for Rails'
  s.description = 'Description of RailsVite.'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails'
end
