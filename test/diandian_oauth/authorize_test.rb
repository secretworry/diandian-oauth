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
    code = '5vrru1'
    unless code.empty?
      assert_nothing_raised do
        client = DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/users/auth/diandian/callback'
        access_token = client.access_token code
        p access_token
      end
    end
  end

end