diandian-oauth
==============

diandian-oauth is a Ruby client for diandian API

Usage
-----

```ruby
# initialize client #

client ||= DiandianOAuth::Client.new config.client_id, config.client_secret, config.client_options

# Assign access_token #

client.access_token = {
          :access_token => '312e7a48-8d05-4cd9-a3a9-044d2f47e2af',
          :refresh_token => "79852349-5f2e-4e3b-93b8-845e239e61ff",
          :token_type => "bearer",
          :expires_in => 604799,
          :expires_at => 1345201711,
          :scope => "write read",
          :uid => "11449"
        }

# Basic usage #

client.user_info # Get user_info

client.user_info! # Get user_info and refresh access_token if it has expired

client.create_post!  :blogCName => BLOG_CNAME,
      :type => 'text',
      :state => 'published',
      :title => 'Hello from diandian ruby client' # create a text post

client.create_post! :blogCName => BLOG_CNAME,
      :type =>  'photo',
      :state => 'published',
      :data => [Faraday::UploadIO.new(JPEG_IMAGE_PATH_1, 'image/jpeg'), Faraday::UploadIO.new(JPEG_IMAGE_PATH_2, 'image/jpeg')],
      :itemDesc => %w[test test]
      :caption => "<p>test</p>" # create a photo post

## Register a callback after the access_token is refreshed

DiandianOAuth::Client.token_refreshed (lambda{|client, uid, token|
  puts "token_refreshed: '#{uid}': #{token}'"
})
```

Supported Interfaces
-------------------

All the interfaces supported(/registerd) can be found at lib/diandian_oauth/api.rb which include

* interface :user_info, Interface::UserInfo
* interface :user_likes, Interface::UserLikes
* interface :user_followings, Interface::UserFollowings
* interface :my_tags, Interface::MyTags
* interface :blog_info, Interface::BlogInfo
* interface :blog_avatar, Interface::BlogAvatar
* interface :blog_followers, Interface::BlogFollowers
* interface :posts, Interface::Posts
* interface :post_info, Interface::PostInfo
* interface :create_post, Interface::CreatePost
* interface :delete_post, Interface::DeletePost
* interface :reblog_post, Interface::ReblogPost
* interface :home_feeds, Interface::HomeFeeds
* interface :tag_feeds, Interface::TagFeeds
* interface :follow, Interface::Follow
* interface :unfollow, Interface::Unfollow
* interface :watch_tag, Interface::WatchTag
* interface :unwatch_tag, Interface::UnwatchTag
* interface :submissions, Interface::Submissions
* interface :submit, Interface::Submit
* interface :reject_submission, Interface::RejectSubmission

Extend Interface
------------------------

1.  Extend DiandianOAuth::API::Interface::Base

    ```ruby
    class NewInterface < DiandianOAuth::API::Interface::Base
    end
    ```
2.  Declare the request verb( default is get) and params

    ```ruby
    verb :get
    param :limit, :required => false
    param :offset, :required => false
    ```
3.  Override request_url to generate request_url
4.  Register interface to the API object

    ```ruby
    API.interface :new_interface, NewInterface
    ```


