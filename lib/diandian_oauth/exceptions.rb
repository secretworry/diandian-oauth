module DiandianOAuth

  class Error < ::StandardError
  end

  class TokenExpiredError < Error
  end

  class RefreshTokenExpireError < Error
  end
  # APIException
  class APIError < Error
  end
  class ParamIsRequiredError < APIError
  end
  class IllegalParamError < APIError
  end
  ## 400000
  class ClientError < APIError
  end

  ## 400001
  class ParameterError < APIError

  end

  ## 400010
  class EmailError < APIError
  end

  ## 400011
  class PasswordError < APIError
  end

  ## 400012
  class EccentricAccountError < APIError

  end

  ## 400013
  class EmailFormatError < APIError

  end

  ## 400014
  class PasswordFormatError < APIError

  end

  ## 400015
  class EmailExistsError < APIError

  end



  ## 400020
  class BindingFailError < APIError

  end

  ## 40003x
  class RelationError < APIError

  end

  ## 400030
  class FollowError < RelationError

  end
  ## 400031
  class UnfollowError < RelationError

  end

  ## 400040
  class IllegalContentError < APIError

  end

  ## 40005x
  class InboxError < APIError

  end

  ## 400050
  class InboxContentCannotBeEmptyError < APIError

  end

  ## 400051
  class InboxContentTooLongError < APIError

  end

  ## 400052
  class InboxClosedError < APIError

  end

  ## 400053
  class CannotSendToOwnBlogError < APIError

  end

  ## 400060
  class OperationTooFastError < APIError

  end

  ## 400070
  class BlogClosedError < APIError

  end


  ## 40008x
  class VerifyCodeError < APIError

  end

  ## 400080
  class VerifyCodeExpiredError < VerifyCodeError

  end


  ## 400081
  class VerifyCodeWrongError < VerifyCodeError

  end

  ## 401xxx
  class AuthorizationError < APIError
  end

  ## 401000
  class UnauthorizedError < AuthorizationError

  end

  ## 403xxx
  class ForbiddenError < APIError

  end

  ## 403000
  class VisitForbiddenError < ForbiddenError

  end

  ## 403001
  class BlogManagerRequiredError < ForbiddenError

  end

  ## 404xxx
  class NotFoundError < APIError

  end

  ## 404000
  class UrlNotFoundError < NotFoundError

  end

  ## 404002
  class BlogNotFoundError < NotFoundError

  end

  ## 404003
  class ContentNotFoundError < NotFoundError

  end

  ## 404004
  class UserNotFoundError < NotFoundError

  end

  ## 500xxx
  class ServerError < APIError

  end

  ## 500000
  class InternalServerError < APIError

  end

  ## 500001
  class PostTypeError < APIError

  end

  ## 500002
  class InboxError < APIError

  end

  ## 503001
  class UpgradingError < APIError

  end

  # End APIException
end