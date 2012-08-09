require File.join( File.dirname(__FILE__), 'test_helper')

class AuthorizeTest < ActiveSupport::TestCase
  CLIENT_ID="fr2ejCbPrO"
  CLIENT_SECRET="C5Cgprqe3DC674vdnaQlujko9ItuSAOB24qa"

  test 'authorize_url' do
    assert_nothing_raised do
      client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET
      puts client.authorize_url %w{read write}
    end
  end

  test 'access_token' do
    code = 'SK377U'
    unless code.empty?
      assert_nothing_raised do
        client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://tree-hollow.dianapp.com/users/auth/diandian/callback'
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