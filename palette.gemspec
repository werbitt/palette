# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "palette/version"

Gem::Specification.new do |s|
  s.name        = "palette"
  s.version     = Palette::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Clayton"]
  s.email       = ["joshua.clayton@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/palette"
  s.summary     = %q{Build Vim colorschemes with ease}
  s.description = %q{Palette provides an easy way to build Vim color schemes}

  all_files = %x{git ls-files}.split("\n").reject {|file| file =~ /gemspec/ }

  s.files         = all_files.reject {|file| file =~ /^(spec|features|cucumber)/ }
  s.test_files    = all_files.select {|file| file =~ /^(spec|features|cucumber)/ }
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "sass",     "3.1.0.alpha.23"

  s.add_development_dependency "rspec",    "1.3.0"
  s.add_development_dependency "mocha",    "0.9.8"
  s.add_development_dependency "bourne",   "1.0"
  s.add_development_dependency "cucumber", "0.9.3"
  s.add_development_dependency "aruba",    "0.2.4"
end
