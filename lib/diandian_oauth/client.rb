require 'oauth2'
require 'diandian_oauth/client/callbacks'
module DiandianOAuth
	class Client
    include DiandianOAuth::Client::Callbacks
		attr_accessor :api, :client
		def initialize client_id, client_secret, options={}
      @api = options[:api] || DiandianOAuth::API.new
      @redirect_uri = options[:redirect_uri]
      @client = OAuth2::Client.new client_id, client_secret, {
          :authorize_url => @api.authorize_url,
          :token_url => @api.token_url
        }
      self.config_client_middleware(@client)
    end

    def config_client_middleware client
      client.options[:connection_build] = Proc.new do |builder|
        builder.request :multipart
        builder.request :url_encoded
        builder.adapter :net_http
      end
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
          @access_token = @client.auth_code.get_token(code_or_hash, {:redirect_uri => @redirect_uri})
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
          begin
            token_expired = false
            response = interface.apply access_token, args[0], &block
            response.validate!
          rescue TokenExpiredError => e
            if DiandianOAuth.logger.debug?
              DiandianOAuth.logger.debug("token '#{access_token.inspect}' expired")
            end
            uid = access_token.params[:uid]
            access_token_inspect = access_token.inspect
            new_access_token = access_token.refresh!
            self.token_refreshed uid, new_access_token
            if DiandianOAuth.logger.debug?
              DiandianOAuth.logger.debug("refreshed '#{access_token_inspect}' of uid: '#{uid}' with '#{new_access_token.inspect}'")
            end
            self.access_token = access_token = new_access_token
            token_expired = true
          end while token_expired
          response
        else
				  interface.apply access_token, args[0], &block
        end # force
			else
				super
			end
		end
	end
end