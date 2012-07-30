require File.join( File.dirname(__FILE__), 'test_helper')

class APITest < ActiveSupport::TestCase

  test 'authorize_url' do
    api = DiandianOAuth::API.new
    puts api.authorize_url
  end

  test 'token_url' do
    api = DiandianOAuth::API.new
    puts api.token_url
  end

  test 'user_info' do
    api = DiandianOAuth::API.new
    user_info_interface = api.interface :user_info
    assert_instance_of(DiandianOAuth::API::Interface::UserInfo, user_info_interface)
    puts user_info_interface.request_url
  end
end