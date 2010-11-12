# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "sick"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Eyberg"]
  s.email       = ["ian@seeinginteractive.com"]
  s.homepage    = "http://github.com/feydr/sick.git"
  s.summary     = "sick k/v storage for random access"
  s.description = "sick k/v storage"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "sick"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['sick']
  s.require_path = 'lib'
end
