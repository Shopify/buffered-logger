class BufferedLogger
  class Configuration
    attr_accessor :flush_at_byte_size, :before_flush, :after_flush

    def initialize
      clear!
    end

    def clear!
      @flush_at_byte_size = nil
      @before_flush = nil
      @after_flush = nil
    end
  end
end
