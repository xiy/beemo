# -*- encoding: utf-8 -*-
require File.expand_path('../lib/beemo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Anthony Gibbins"]
  gem.email         = ["xiy3x0@gmail.com"]
  gem.description   = %q{TODO: Mathematically awesome web scraping.}
  gem.summary       = %q{TODO: Mathematically awesome web scraping.}
  gem.homepage      = "http://github.com/xiy/beemo"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scrapes"
  gem.require_paths = ["lib"]
  gem.version       = Beemo::VERSION

  gem.add_dependency 'capybara'
  gem.add_dependency 'capybara-webkit'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
