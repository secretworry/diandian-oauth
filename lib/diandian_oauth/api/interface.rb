module DiandianOAuth
  class API
    module Interface
      def self.included base
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end
      module ClassMethods
        def url_for path, options = {}
          protocol = options[:protocol] || "https"
          version = options[:version] || API::VERSION
          host = options[:host] || API::HOST
          path = if options[:no_version] then path else "/#{version}#{path}" end
          "#{protocol}://#{host}#{path}"
        end

        def interface name, interface_class
          self.interfaces[name.to_sym] = interface_class.new
        end

        def interfaces
          @interfaces ||= {}
        end
      end

      module InstanceMethods
        def interface interface_name
          self.class.interfaces[interface_name]
        end
      end
      class Param
        attr_accessor :name, :required

        DEFAULT_OPTIONS = { required: true }
        def initialize name, options = {}
          options = DEFAULT_OPTIONS.merge( options)
          @name = name
          @required = options[:required]
        end
      end #Param

      class Base
        def request_url params = {}
          raise 'subclasses must implement this method'
        end

        # if and error occurs raise corresponding errors
        def apply! access_token, params, &block
          response = self.apply access_token, params, &block
          response.validate!
          response
        end

        def apply access_token, params, &block
          raise TokenExpiredError if access_token.expired?
          params ||= {}
          action = case request_verb
          when /get/ then :get
          when /post/ then :post
          when /put/ then :put
          when /delete/ then :delete
          else raise "unrecognized verb '#{request_verb}'"
          end # case
          options = {
            :body => extract_params(params),
            :raise_errors => false,
            :parse => :json
          }
          request_url = self.request_url(params)
          if DiandianOAuth.logger.debug?
            DiandianOAuth.logger.debug("request with action:'#{action}', request_url:'#{request_url}', options:'#{options}'")
          end
          access_token.request( action, request_url, options, &block)
        end
        protected
        def request_verb
          self.class.verb
        end
        def extract_params params
          params.symbolize_keys!
          self.class.params.each_pair.reduce({}) do |result, ele|
            key = ele[0]
            param = ele[1]
            param_value = params[key]
            if param_value
              result[key] = param_value
            elsif param.required
              raise ParamIsRequiredError.new( "'#{key}' is required")
            end
            result
          end
        end

        class << self
          def param name, options = {}
            params[name.to_sym] = Param.new( name.to_s, options)
          end
          def verb verb=nil
            @verb = verb if verb
            @verb ||= 'get'
          end
          def params
            @params ||= {}
          end
        end # class
      end # Base

      class UserInfo < Base
        def request_url params={}
          API.url_for '/user/info'
        end
      end #UserInfo

      class UserLikes < Base
        param :limit, :required => false
        param :offset, :required => false
        def request_url params={}
          API.url_for '/user/likes'
        end
      end #UserLikes

      class UserFollowings < Base
        param :limit, :required => false
        param :offset, :required => false
        def request_url params={}
          API.url_for '/user/following'
        end
      end #UserFollowing

      class MyTags < Base
        def request_url params={}
          API.url_for '/tag/mytags'
        end
      end #TagMyTags

      class Blog < Base
        protected
        def blog_request_url params
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          API.url_for "/blog/#{blog_cname||blog_uuid}"
        end
      end #BlogInterface

      class BlogInfo < Base
        def request_url params={}
          "#{blog_request_url}/info"
        end
      end #BlogInfo

      class BlogAvatar < Base
        VALID_SIZES = %w{57 72 114 144}
        def request_url params={}
          path = [self.blog_request_url(params), 'avatar'].join('/')
          size = params[:size]
          if size
            unless BlogAvatar.is_valid_size size
              raise IllegalParamError.new("'#{size}' is illegal")
            end
          end # if
        end

        def self.is_valid_size size
          VALID_SIZES.include? size.to_s
        end

      end #BlogAvatar

      class BlogFollowers < Base
        param :limit, :required => false
        param :offset, :required => false
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          API.url_for "/blog/#{blog_cname || blog_uuid}/info"
        end
      end #BlogFollowers

      class Posts < Base
        param :tag, :required => false
        param :limit, :required => false
        param :offset, :required => false
        param :id, :required => false
        param :reblogInfo, :required => false
        param :notesInfo, :required => false
        param :filter, :required => false
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          path = "/blog/#{blog_cname||blog_uuid}/posts"
          if params[:type]
            path = path + "/#{type}"
          end
          API.url_for path
        end
      end # Posts

      class CreatePost < Base
        verb :post
        param :type, :required => true
        param :state, :required => true
        param :tag, :required => false
        param :slug, :required => false
        #text
        param :title, :required => false
        param :body, :required => false
        #photo
        param :caption, :required => false
        param :layout, :required => false
        param :data, :required => false
        param :itemDesc, :required => false
        #link
        param :title, :required => false
        param :url, :required => false
        param :description, :required => false

        #audio
        param :caption, :required => false
        param :data, :required => false
        param :musicName, :required => false
        param :musicSinger, :required => false
        param :albumName, :required => false

        #video
        param :caption, :required => false
        param :sourceUrl, :required => false

        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          type = params[:type]
          raise ParamIsRequiredError.new("type is required for interface #{self.class.name}") unless type
          API.url_for "/blog/#{blog_cname || blog_uuid}/post"
        end
      end

      class EditPost < Base
        verb :post
        param :id, :required => true
        param :tag, :required => false
        param :slug, :required => false
        #text
        param :title, :required => false
        param :body, :required => false
        #photo
        param :caption, :required => false
        param :layout, :required => false
        param :data, :required => false
        param :itemDesc, :required => false
        #link
        param :title, :required => false
        param :url, :required => false
        param :description, :required => false

        #audio
        param :caption, :required => false
        param :data, :required => false
        param :musicName, :required => false
        param :musicSinger, :required => false
        param :albumName, :required => false

        #video
        param :caption, :required => false
        param :sourceUrl, :required => false

        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          type = params[:type]
          raise ParamIsRequiredError.new("type is required for interface #{self.class.name}") unless type
          API.url_for "/blog/#{blog_cname || blog_uuid}/post/edit"
        end
      end

      class DeletePost < Base
        verb :post
        param :id, :required => true
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          API.url_for "/blog/#{blog_cname || blog_uuid}/post/delete"
        end
      end

      class ReblogPost < Base
        verb :post
        param :id, :required => true
        param :tag, :required => false
        param :comment, :required => false
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          API.url_for "/blog/#{blog_cname || blog_uuid}/post/reblog"
        end
      end

      class HomeFeeds < Base
        param :limit, :required => false
        param :offset, :required => false
        param :type, :required => false
        param :sinceId, :required => false
        param :reblogInfo, :required => false
        param :notesInfo, :required => false
        param :filter, :required => false
        def request_url params={}
          API.url_fo "/user/home"
        end
      end # Home

      class TagFeeds < Base
        param :limit, :required => false
        param :tag, :required => false
        param :sinceId, :required => false
        param :reblogInfo, :required => false
        param :notesInfo, :required => false
        param :filter, :required => false

        def request_url params={}
          tag = params[:tag]
          raise ParamIsRequiredError.new("tag is required for interface #{self.class.name}") unless tag
          API.url_for "/tag/posts/#{tag}"
        end
      end #TagFeeds

      class Follow < Base
        verb :post
        param :blogCName, :required => true
        def request_url params={}
          API.url_for "/user/follow"
        end
      end # Follow

      class Unfollow < Base
        verb :post
        param :blogCName, :required => true
        def request_url params={}
          API.url_for '/user/unfollow'
        end
      end # Unfollow

      class WatchTag < Base
        verb :post
        def request_url params={}
          tag = params[:tag]
          raise ParamIsRequiredError.new("tag is required for interface #{self.class.name}") unless tag
          API.url_for '/tag/watch/#{tag}'
        end
      end

      class UnwatchTag < Base
        verb :post
        def request_url params={}
          tag = params[:tag]
          raise ParamIsRequiredError.new("tag is required for interface #{self.class.name}") unless tag
          API.url_for '/tag/watch/#{tag}'
        end
      end

      class Submissions < Base
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          API.url_for "/blog/#{blog_cname||blog_uuid}/submission"
        end
      end #Submissions

      class Submit < Base
        verb :post
        param :tag, :required => false
        param :slug, :required => false
        #text
        param :title, :required => false
        param :body, :required => false
        #photo
        param :caption, :required => false
        param :layout, :required => false
        param :data, :required => false
        param :itemDesc, :required => false
        #link
        param :title, :required => false
        param :url, :required => false
        param :description, :required => false

        #audio
        param :caption, :required => false
        param :data, :required => false
        param :musicName, :required => false
        param :musicSinger, :required => false
        param :albumName, :required => false

        #video
        param :caption, :required => false
        param :sourceUrl, :required => false

        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          type = params[:type]
          raise ParamIsRequiredError.new("type is required for interface #{self.class.name}") unless type
          API.url_for "/blog/#{blog_cname || blog_uuid}/submission/#{type}"
        end
      end

      class RejectSubmission < Base
        verb :post
        param :reason, :required => false
        def request_url params={}
          blog_cname = params[:blogCName]
          blog_uuid = params[:blogUuid]
          raise ParamIsRequiredError.new("blogCName or blogUuid is required for interface #{self.class.name}") unless blog_cname || blog_uuid
          id = params[:id]
          raise ParamIsRequiredError.new("id is required for interface #{self.class.name}") unless id
          API.url_for "/blog/#{blog_cname || blog_uuid}/submission/reject/#{id}"
        end
      end
    end # Interface
  end
end