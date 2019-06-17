# frozen_string_literal: true

require "logger"

class BufferedLogger < defined?(::ActiveSupport::Logger) ? ::ActiveSupport::Logger : ::Logger
  VERSION = "2.1.0"
end
