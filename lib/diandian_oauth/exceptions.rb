module DiandianOAuth

  class OAuthException < ::Exception
  end

  class TokenExpiredException < OAuthException
  end

  class RefreshTokenExpireException < OAuthException
  end
  # APIException
  class APIException < OAuthException
  end
  class ParamIsRequiredException < APIException
  end
  class IllegalParamException < APIException
  end
  # End APIException
end