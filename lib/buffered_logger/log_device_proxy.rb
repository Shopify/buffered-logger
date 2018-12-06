require "thread"

class BufferedLogger
  class LogDeviceProxy
    THREAD_LOCAL_STRING_IO = :"BufferedLogger::LogDeviceProxy::string_io"
    THREAD_LOCAL_FLUSHING = :"BufferedLogger::LogDeviceProxy::flushing"

    def initialize(logdev)
      @logdev = logdev
      destroy_thread_local
    end

    def close
      @logdev.close
    end

    def end
      @logdev.write(string_io.string)
      destroy_thread_local
    end

    def flush
      @logdev.write(string_io.string)
      string_io.string.clear
    end

    def start
      self.string_io = StringIO.new
    end

    def started?
      !!string_io
    end

    def write(message)
      unless started?
        @logdev.write(message)
        return
      end

      if flush_required? && !flushing?
        self.flushing = true
        BufferedLogger.configuration.before_flush.call if BufferedLogger.configuration.before_flush
        self.end
        start
        BufferedLogger.configuration.after_flush.call if BufferedLogger.configuration.after_flush
      end
      string_io.write(message)
    end

    def current_log
      string_io.string.dup
    end

    private

    def string_io
      Thread.current.thread_variable_get(THREAD_LOCAL_STRING_IO)
    end

    def string_io=(string_io)
      Thread.current.thread_variable_set(THREAD_LOCAL_STRING_IO,string_io)
    end

    def flushing?
      Thread.current.thread_variable_get(THREAD_LOCAL_FLUSHING)
    end

    def flushing=(flushing)
      Thread.current.thread_variable_set(THREAD_LOCAL_FLUSHING, flushing)
    end

    def destroy_thread_local
      self.string_io = nil
      self.flushing = nil
    end

    def flush_required?
      return false unless (target_bytes = BufferedLogger.configuration.flush_at_byte_size)
      return false unless string_io.string.length >= target_bytes

      true
    end
  end
end
