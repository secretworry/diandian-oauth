require File.join( File.dirname(__FILE__), 'test_helper')

class InterfaceTest < ActiveSupport::TestCase
  CLIENT_ID="fr2ejCbPrO"
  CLIENT_SECRET="C5Cgprqe3DC674vdnaQlujko9ItuSAOB24qa"
  ACCESS_TOKEN = {
      :access_token => '298b54f8-8ef1-40c7-9c1a-98df8386ea1a',
      :refresh_token => "850b3a3e-7ff0-43a0-9a65-7c7fecb70c5a",
      :token_type => "bearer",
      :expires_in => 3599,
      :expires_at => 1344161999,
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
    p client.user_info
  end

  test 'user_info!' do
    client = self.client
    client.access_token = ACCESS_TOKEN.merge(:expires_at => Time.now.to_i - 1.day.to_i)
    puts "expired?: '#{client.access_token.expired?}'"
    p client.user_info!
  end

  test 'create_post' do
    client = self.client
    client.access_token = ACCESS_TOKEN
    p client.create_post  :blogCName => 'secretworry.diandian.com',
      :type => 'text',
      :state => 'published',
      :title => 'Hello from diandian ruby client'
  end

  test 'submissions' do
    client = self.client
    client.access_token = ACCESS_TOKEN
    p client.submissions :blogCName => 'secretworry.diandian.com'
  end

  test 'delete_post' do
    client = self.client
    client.access_token = ACCESS_TOKEN
    p client.delete_post :blogCName => 'secretworry.diandian.com', :id => '3fdc4740-dcce-11e1-a2d7-782bcb43b268'
  end

  test 'posts' do
    client = self.client
    client.access_token= ACCESS_TOKEN
    p client.posts :blogCName => 'secretworry'
  end

  def client
    DiandianOAuth::Client.token_refreshed (lambda{|client, token|
      p "token_refreshed: '#{token}'"
    })
    @client ||= DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
  end
end