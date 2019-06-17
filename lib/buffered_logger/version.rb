# frozen_string_literal: true

require "logger"

class BufferedLogger < defined?(::ActiveSupport::Logger) ? ::ActiveSupport::Logger : ::Logger
  VERSION = "2.0.3"
end
