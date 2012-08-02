require File.join( File.dirname(__FILE__), 'test_helper')

class AuthorizeTest < ActiveSupport::TestCase
  CLIENT_ID="3zgJwues92"
  CLIENT_SECRET="1rxLZr5R4sweGUATGig25VBc1ka1xDEpkIqJ"

  test 'authorize_url' do
    assert_nothing_raised do
      client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET
      puts client.authorize_url %w{read write}
    end
  end

  test 'access_token' do
    code = '7KhUBh'
    unless code.empty?
      assert_nothing_raised do
        client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
        access_token = client.access_token.auth code
      end
    end
  end

end