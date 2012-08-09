require File.join( File.dirname(__FILE__), 'test_helper')

class InterfaceTest < ActiveSupport::TestCase
  CLIENT_ID="fr2ejCbPrO"
  CLIENT_SECRET="C5Cgprqe3DC674vdnaQlujko9ItuSAOB24qa"
  ACCESS_TOKEN = {
      :access_token => '66e4ca32-0aa8-4f92-a4a8-614218546e85',
      :refresh_token => "420db62f-c1f7-4199-890c-edf2520d4321",
      :token_type => "bearer",
      :expires_in => 3599,
      :expires_at => 1344515869,
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
    p client.create_post!  :blogCName => 'secretworry.diandian.com',
      :type => 'text',
      :state => 'published',
      :title => 'Hello from diandian ruby client'
  end

  test 'create_photo_post' do
    client = self.client
    client.access_token = ACCESS_TOKEN
    Faraday::Request.register_middleware :diandian_multipart => Faraday::Request::DiandianMultipart
    p client.user_info!
    p client.create_post! :blogCName => 'tree-hollow.diandian.com',
      :type =>  'photo',
      :state => 'published',
      :data => [Faraday::UploadIO.new('/Users/siyudu/Pictures/test/blue_700_342.jpg', 'image/jpeg'), Faraday::UploadIO.new('/Users/siyudu/Pictures/test/white_700_342.jpg', 'image/jpeg')]
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
    DiandianOAuth::Client.token_refreshed (lambda{|client, uid, token|
      p "token_refreshed: '#{uid}': #{token}'"
    })
    @client ||= DiandianOAuth::Client.new CLIENT_ID, CLIENT_SECRET, :redirect_uri => 'http://example.com/callback'
  end
end