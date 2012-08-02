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
    interface :create_post, Interface::CreatePost
    interface :delete_post, Interface::DeletePost
    interface :reblog_post, Interface::ReblogPost
    interface :home_feeds, Interface::HomeFeeds
    interface :tag_feeds, Interface::TagFeeds
    interface :follow, Interface::Follow
    interface :unfollow, Interface::Unfollow
    interface :watch_tag, Interface::WatchTag
    interface :unwatch_tag, Interface::UnwatchTag
    interface :submissions, Interface::Submissions
    interface :submit, Interface::Submit
    interface :reject_submission, Interface::RejectSubmission
	end
end