require "test_helper"

describe BufferedLogger::LogDeviceProxy do
  before do
    BufferedLogger.reset_configuration!
    @logdev = mock()
    @proxy = BufferedLogger::LogDeviceProxy.new(@logdev)
  end

  it "should call write" do
    @logdev.expects(:write)
    @proxy.write("message")
  end

  it "should call close on the logdev when close is called" do
    @logdev.expects(:close)
    @proxy.close
  end

  it "should not call write on the logdev once started" do
    @logdev.expects(:write).never
    @proxy.start
    @proxy.write("message")
  end

  it "should be started? once started" do
    @proxy.start
    assert @proxy.started?
  end

  it "should call write once started and ended" do
    @logdev.expects(:write)
    @proxy.start
    @proxy.write("message")
    @proxy.end
  end

  it "should buffer all writes and write them once" do
    @logdev.expects(:write).with("123")
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    @proxy.write("3")
    @proxy.end
  end

  it "should flush the buffered log and then start buffering again" do
    @logdev.expects(:write).with("12")
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    @proxy.flush
    @proxy.write("3")
  end

  it "should allow access to the current buffer in string form" do
    @proxy.start
    @proxy.write("1")
    @proxy.write("2")
    assert_equal "12", @proxy.current_log
  end

  it "does not clear the buffer if the byte size is not hit" do
    BufferedLogger.configure do |config|
      config.flush_at_byte_size = 10
    end
    @proxy.start
    @proxy.write("aaaaa")
    @proxy.write("bbb")
    assert_equal "aaaaabbb", @proxy.current_log
  end

  it "clears the buffer if the byte size is hit" do
    BufferedLogger.configure do |config|
      config.flush_at_byte_size = 10
    end
    @proxy.start
    @logdev.expects(:write).with("aaaaaaaaaaaaaaa")
    @proxy.write("aaaaaaaaaaaaaaa")

    @proxy.write("bbb")
    assert_equal "bbb", @proxy.current_log
  end

  it "allows running procs that log" do
    BufferedLogger.configure do |config|
      config.flush_at_byte_size = 10
      config.before_flush = proc { @proxy.write("Flushing logs") }
      config.after_flush = proc { @proxy.write("Flushed logs") }
    end
    @proxy.start
    @logdev.expects(:write).with("aaaaaaaaaaaaaaaFlushing logs")
    @proxy.write("aaaaaaaaaaaaaaa")

    @proxy.write("bbb")
    assert_equal "Flushed logsbbb", @proxy.current_log
  end
end
