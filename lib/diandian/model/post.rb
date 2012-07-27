module Diandain
	module Model
		class Post < Diandian::Model::Base
			# define common attributes
			define_attribute_methods [:format, :blogName, :blogCName, :postId, :postUrl, :type, :createTime, :tag, :commentCount, :reblogCount, :likeCount]
			# define reblogInfo related attribute
			define_attribute_methods [:reblogedFromUrl, :reblogedFromName, :reblogedFromTitle, :reblogedRootUrl, :reblogedRootName, :reblogedRootTitle]
			# define text specified attributes
			define_attribute_methods [:title, :body]
			# define photo specified attributes
			define_attribute_methods [:caption, :photos]
			# define audio specified attributes
			define_attribute_methods [:musicId, :audioType, :cover, :caption, :musicName, :playerUrl, :musicSinger, :coverNormal, :coverLarge, :coverSmall, :albumName, :musicName, :albumId, :artistId]
			# define video specified attributes
			define_attribute_methods [:caption, :sourceUrl, :sourceTitle, :videoType, :videoId, :playerUrl, :videoImageUrl]
			# define link specified attributes
			define_attribute_methods [:title, :url, :description]
		end
	end
end