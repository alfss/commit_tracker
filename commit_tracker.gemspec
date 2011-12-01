lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include? lib

require "commit_tracker/version"

Gem::Specification.new do |s|
  s.name        = "commit_tracker"
  s.version     = CommitTracker::Version
  s.authors     = "Sergey V. Kravchuk"
  s.email       = "alfss.obsd@gmail.com"
  s.homepage    = "https://github.com/alfss/commit_tracker"
  s.summary     = "client tracking system"
  s.description = "client tracking system"

  s.rubyforge_project = s.name

  s.add_dependency "builder",  ">= 2.1.2"
  s.add_dependency "savon",    "~> 0.9.7"
  s.add_dependency "nokogiri", ">= 1.4.0"

  s.add_development_dependency "rake",    "~> 0.8.7"
  s.add_development_dependency "rspec",   "~> 2.5.0" 

  s.files = `git ls-files`.split("\n")
  s.require_path = "lib"
end
