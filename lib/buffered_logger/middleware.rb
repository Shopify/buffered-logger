# frozen_string_literal: true

class BufferedLogger
  class Middleware
    def initialize(app, logger)
      @app = app
      @logger = logger
    end

    def call(env)
      @logger.start { @app.call(env) }
    end
  end
end
