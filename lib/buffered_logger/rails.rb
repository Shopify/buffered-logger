# frozen_string_literal: true

require "buffered_logger"
require "rails"

class BufferedLogger
  class Railtie < Rails::Railtie
    initializer :buffered_logger, before: :initialize_logger do |app|
      log_dev = nil
      if ENV['RAILS_LOG_TO_STDOUT'].present?
        log_dev = STDOUT
      else
        path = if Rails::VERSION::STRING >= "3.1"
          app.paths["log"].first
        else
          app.paths.log.to_a.first
        end

        log_dev = File.open(path, "a")
      end
      log_dev.binmode
      log_dev.sync = true

      app.config.logger = BufferedLogger.new(log_dev)
      app.config.logger.level = BufferedLogger.const_get(app.config.log_level.to_s.upcase)
      app.config.middleware.insert(0, BufferedLogger::Middleware, app.config.logger)
    end
  end
end
