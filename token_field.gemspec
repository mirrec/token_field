$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "token_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "token_field"
  s.version     = TokenField::VERSION
  s.authors     = ["Miroslav Hettes"]
  s.email       = ["hettes@webynamieru.sk"]
  s.homepage    = "https://github.com/mirrec/token_field"
  s.summary     = "Form helper input for jquery token input"
  s.description = "Form helper with how to section for using token input jquery plugin in application"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.6"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3", "~> 1.3.6"
  s.add_development_dependency "rspec-rails", "~> 2.11.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.1.0"
  s.add_development_dependency "database_cleaner", "~> 0.8.0"
  s.add_development_dependency "capybara", "~> 2.5.0"
  s.add_development_dependency "capybara-webkit", "~> 1.7.1"
  s.add_development_dependency "capybara-screenshot", "~> 1.0.11"
end
