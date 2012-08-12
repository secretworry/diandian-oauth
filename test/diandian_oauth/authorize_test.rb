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
    code = 'TmqTFO'
    unless code.empty?
      assert_nothing_raised do
        client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
        access_token = client.access_token code
        puts access_token.inspect
        puts %Q`{
          :access_token => '#{access_token.token}',
          :refresh_token => "#{access_token.refresh_token}",
          :token_type => "bearer",
          :expires_in => #{access_token.expires_in},
          :expires_at => #{access_token.expires_at},
          :scope => "write read",
          :uid => "#{access_token.params['uid']}"
        }`
      end
    end
  end

end