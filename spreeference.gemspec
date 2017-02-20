$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spreeference/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spreeference"
  s.version     = Spreeference::VERSION
  s.authors     = ["hugomarquez", "Spree Commerce"]
  s.email       = ["hugomarquez.dev@gmail.com"]
  s.homepage    = "https://github.com/hugomarquez/spreeference"
  s.summary     = "application-wide and per model cached and persisted preferences"
  s.description = "application-wide and per model cached and persisted preferences"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.md", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "thin"
end
