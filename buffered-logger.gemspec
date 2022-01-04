# frozen_string_literal: true

require File.expand_path("../lib/buffered_logger/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "buffered-logger"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = <<~EOM
    buffered-logger is designed to be used in multithreaded or multifiber rack servers and includes a middleware to
    automatically capture and write the buffered log statements during each request.
    This is ideal for keeping requests together for log parsing software such as splunk
  EOM
  gem.summary = <<~EOM
    buffered-logger is a concurrency safe logger.
    It buffers each logging statement and writes to the log file all at once.
  EOM
  gem.homepage    = "http://samuelkadolph.github.com/buffered-logger/"
  gem.version     = BufferedLogger::VERSION

  gem.files       = Dir["lib/**/*"]
  gem.test_files  = Dir["test/**/*_test.rb"]

  gem.required_ruby_version = ">= 2.4.0"

  gem.add_development_dependency("mocha", "~> 1.4.0")
  gem.add_development_dependency("rake", "~> 13.0.3")
  gem.add_development_dependency("minitest", "~> 5.11.3")
end
