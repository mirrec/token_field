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

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "pry"
  s.add_development_dependency "selenium-webdriver"
end
