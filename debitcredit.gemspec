$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "debitcredit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "debitcredit"
  s.version     = Debitcredit::VERSION
  s.authors     = ["Vitaly Kushner"]
  s.email       = ["vitaly@astrails.com"]
  s.homepage    = "http://github.com/vitaly/debitcredit"
  s.summary     = "Double entry accounting for Rails applications"
  s.description = "Double entry accounting for Rails applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "docile"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.7.2"
end
