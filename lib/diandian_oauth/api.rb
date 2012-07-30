require 'diandian_oauth/api/interface'
module DiandianOAuth
  class API
	  HOST='api.diandian.com'
		VERSION='v1'
		class APIException < Exception
		end
		class ParamIsRequiredException < APIException 
		end
		class IllegalParamException < APIException
		end
		class TokenExpiredException < APIException
		end
    def authorize_url
      'https://api.diandian.com/oauth/authorize'
    end

    def token_url
      'https://api.diandian.com/oauth/token'
    end

		include Interface
		interface :user_info, Interface::UserInfo
	end
end