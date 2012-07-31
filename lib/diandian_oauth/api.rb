require 'diandian_oauth/api/interface'
module DiandianOAuth
  class API
	  HOST='api.diandian.com'
		VERSION='v1'


    def authorize_url
      'https://api.diandian.com/oauth/authorize'
    end

    def token_url
      'https://api.diandian.com/oauth/token'
    end

		include Interface
		interface :user_info, Interface::UserInfo
    interface :user_likes, Interface::UserLikes
    interface :user_followings, Interface::UserFollowings
    interface :my_tags, Interface::MyTags
    interface :blog, Interface::Blog
    interface :blog_info, Interface::BlogInfo
    interface :blog_avatar, Interface::BlogAvatar
    interface :blog_followers, Interface::BlogFollowers
    interface :posts, Interface::Posts
    interface :home_feeds, Interface::HomeFeeds
    interface :tag_feeds, Interface::TagFeeds
    interface :follow, Interface::Follow
    interface :unfollow, Interface::Unfollow
    interface :submissions, Interface::Submissions
	end
end