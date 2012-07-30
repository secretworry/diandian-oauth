require File.join( File.dirname(__FILE__), 'test_helper')

class InterfaceTest < ActiveSupport::TestCase
  CLIENT_ID="3zgJwues92"
  CLIENT_SECRET="1rxLZr5R4sweGUATGig25VBc1ka1xDEpkIqJ"
  ACCESS_TOKEN = {
      :access_token => '9986f9cb-75d6-441a-8109-bbe9ddd1086b',
      :refresh_token => "c27e5e5b-6837-48c5-8fa1-5eab4efc4158",
      :token_type => "bearer",
      :expires_in => 3599,
      :expires_at => 1343658619,
      :scope => "write read",
      :uid => "11449"
  }

  test 'refresh_token' do
    client = self.client
    client.access_token= ACCESS_TOKEN
    p client.access_token.refresh!
  end

  test 'user_info' do
    client = self.client
    client.access_token= ACCESS_TOKEN
    p client.access_token
    begin
      p client.user_info
    rescue DiandianOAuth::API::TokenExpiredException => e
    end
  end

  def client
    @client ||= DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
  end
end