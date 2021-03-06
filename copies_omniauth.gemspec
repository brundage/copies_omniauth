$:.push File.expand_path('../lib', __FILE__)
require 'copies_omniauth/version'

Gem::Specification.new do |s|
  s.name = 'copies_omniauth'
  s.version = CopiesOmniauth::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Dean Brundage"]
  s.email = "dean@deanbrundage.com"
  s.homepage = 'https://github.com/brundage/copies_omniauth'
  s.summary = "Utility for copying information from OmniAuth into other models"
  # s.description = ""

  s.files = `git ls-files lib`.split("\n") + ['Gemfile','Rakefile','README.markdown']
  s.test_files = `git ls-files spec`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
end

