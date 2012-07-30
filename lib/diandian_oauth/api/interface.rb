
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
        def apply access_token, params, &block
          raise TokenExpiredException if access_token.expired?
          params ||= {}
          action = case request_verb
          when /get/ then :get
          when /post/ then :post
          when /put/ then :put
          when /delete/ then :delete
          else raise "unrecognized verb '#{request_verb}'"
          end # case
          options = {
            :params => extract_params(params),
            :raise_errors => false,
            :parse => :json
          }
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
            if param_value && param.required
              result[key] = param_value
            elsif param.required
              raise ParamIsRequiredException.new( "'#{key}' is required")
            end
            result
          end
        end

        class << self
          def param name, options = {}
            params[name.to_sym] = Param.new( name.to_s, options)
          end
          def verb
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

      class UserFollowing < Base
        param :limit, :required => false
        param :offset, :required => false
        def request_url params={}
          API.url_for '/user/following'
        end
      end #UserFollowing

      class TagMyTags < Base
        def request_url params={}
          API.url_for '/tag/mytags'
        end
      end #TagMyTags

      class BlogInterface < Base
        protected
        def blog_request_url params
          blog_cname = params[:blogCName]
          raise ParamIsRequiredException.new("blogCName is required for interface #{self.class.name}") unless blog_cname
          API.url_for "/blog/#{blog_cname}"
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
              raise IllegalParamException.new("'#{size}' is illegal")
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
          raise ParamIsRequiredException.new("blogCName is required for interface #{BlogInfo.name}") unless blog_cname
          API.url_for "/blog/#{blog_cname}/info"
        end
      end #BlogFollowers
    end # Interface
  end
end