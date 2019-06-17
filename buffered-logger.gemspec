require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/buffered_logger/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "buffered-logger"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = readme.description
  gem.summary     = readme.summary
  gem.homepage    = "http://samuelkadolph.github.com/buffered-logger/"
  gem.version     = BufferedLogger::VERSION

  gem.files       = Dir["lib/**/*"]
  gem.test_files  = Dir["test/**/*_test.rb"]

  gem.required_ruby_version = ">= 2.4.0"

  gem.add_development_dependency "mocha", "~> 1.4.0"
  gem.add_development_dependency "rake", "~> 12.3.1"
  gem.add_development_dependency "minitest", "~> 5.11.3"
end
