require 'oauth2'
module DiandianOAuth
	class Client
		attr_accessor :api
		def initialize client_id, client_secret, options={}
      @api = options[:api] || DiandianOAuth::API.new
      @redirect_uri = options[:redirect_uri]
      @client = OAuth2::Client.new client_id, client_secret, {
          :authorize_url => @api.authorize_url,
          :token_url => @api.token_url
        }
		end

		def authorize_url response_type='code', scope=[]
      if response_type.is_a? Array
        scope = response_type
        response_type = 'code'
      end
      @client.authorize_url(
          :client_id => @client.id,
          :response_type => response_type,
          :scope => scope.join(',')
      )
    end
    def access_token= hash
      @access_token = case hash
        when Hash then OAuth2::AccessToken.from_hash(@client, hash)
        when OAuth2::AccessToken then hash
        else
          raise 'illegal argument hash'
      end
    end
		def access_token code_or_hash=nil
      return @access_token if @access_token
			return nil unless code_or_hash
      if code_or_hash.is_a? Hash
        @access_token = OAuth2::AccessToken.from_hash(@client, code_or_hash)
      else
        begin
          DiandianOAuth.logger.warn('redirect_url is required for authorization_code grant type') unless @redirect_uri
          @access_token = @client.get_token(
              :client_id => @client.id,
              :client_secret => @client.secret,
              :grant_type => 'authorization_code',
              :code => code_or_hash,
              :redirect_uri => @redirect_uri
          )
        rescue OAuth2::Error => e
          DiandianOAuth.logger.error e.to_s
          raise e
        end
      end
      @access_token
    end

		def method_missing(meth, *args, &block)
      force = meth.to_s =~ /!$/
      meth = $` if force
			interface = @api.interface meth.to_sym
			if interface
        access_token = self.access_token
        raise 'access_token is required' unless access_token
        response = if force
          interface.apply! access_token, args[0], &block
        else
				  interface.apply access_token, args[0], &block
        end # force
        DiandianOAuth::Response.from_response response
			else
				super
			end
		end
	end
end