require "test_helper"

describe BufferedLogger::Configuration do
  it "assigns configuration values" do
    BufferedLogger.configure do |config|
      config.flush_at_byte_size = 1000
    end

    assert_equal 1000, BufferedLogger.configuration.flush_at_byte_size
  end
end
