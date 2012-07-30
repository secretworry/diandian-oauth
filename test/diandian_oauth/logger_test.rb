require File.join( File.dirname(__FILE__), 'test_helper')

class LoggerTest < ActiveSupport::TestCase
  test 'default logger' do
    assert_nothing_raised do
      DiandianOAuth.logger.info("test")
    end
  end

  test 'change logger' do
    assert_nothing_raised do
      DiandianOAuth.logger(STDERR)
      DiandianOAuth.logger.info("test")
    end
  end
end