require File.join( File.dirname(__FILE__), 'test_helper')

class InterfaceTest < ActiveSupport::TestCase
  CLIENT_ID="3zgJwues92"
  CLIENT_SECRET="1rxLZr5R4sweGUATGig25VBc1ka1xDEpkIqJ"
  ACCESS_TOKEN = {
      :access_token => 'adbab585-ea39-47e0-87ce-da7700fd3d9b',
      :refresh_token => "79852349-5f2e-4e3b-93b8-845e239e61ff",
      :token_type => "bearer",
      :expires_in => 604799,
      :expires_at => 1344317317,
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
    begin
      p client.user_info
    rescue DiandianOAuth::API::TokenExpiredException => e
    end
  end

  test 'posts' do
    client = self.client
    client.access_token= ACCESS_TOKEN
    p client.posts :blogCName => 'secretworry'
  end

  def client
    @client ||= DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
  end
end