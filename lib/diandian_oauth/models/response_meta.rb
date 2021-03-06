module DiandianOAuth
  class ResponseMeta
    attr_accessor :status, :message
    def self.from_response response_json
      meta = response_json['meta']
      response_meta = ResponseMeta.new
      response_meta.status = meta['status']
      response_meta.message = meta['msg']
      response_meta
    end

    def success?
      self.validate
    end

    def validate
      self.status == 200
    end

    def validate!
      if !self.validate
        exception =
            case self.status
              when 400000 then DiandianOAuth::ClientError
              when 400001 then DiandianOAuth::ParameterError
              when 400010 then DiandianOAuth::EmailError
              when 400011 then DiandianOAuth::PasswordError
              when 400012 then DiandianOAuth::EccentricAccountError
              when 400013 then DiandianOAuth::EmailFormatError
              when 400014 then DiandianOAuth::PasswordFormatError
              when 400015 then DiandianOAuth::EmailExistsError
              when 400020 then DiandianOAuth::BindingFailError
              when 400030 then DiandianOAuth::FollowError
              when 400031 then DiandianOAuth::UnfollowError
              when 400040 then DiandianOAuth::IllegalContentError
              when 400050 then DiandianOAuth::InboxContentCannotBeEmptyError
              when 400051 then DiandianOAuth::InboxContentTooLongError
              when 400052 then DiandianOAuth::InboxClosedError
              when 400053 then DiandianOAuth::CannotSendToOwnBlogError
              when 400060 then DiandianOAuth::OperationTooFastError
              when 400070 then DiandianOAuth::BlogClosedError
              when 400080 then DiandianOAuth::VerifyCodeExpiredError
              when 400081 then DiandianOAuth::VerifyCodeWrongError
              when 401000 then DiandianOAuth::UnauthorizedError
              when 403000 then DiandianOAuth::VisitForbiddenError
              when 403001 then DiandianOAuth::BlogManagerRequiredError
              when 404002 then DiandianOAuth::BlogNotFoundError
              when 404003 then DiandianOAuth::ContentNotFoundError
              when 404004 then DiandianOAuth::UserNotFoundError
              when 500000 then DiandianOAuth::InternalServerError
              when 500001 then DiandianOAuth::PostTypeError
              when 500002 then DiandianOAuth::InboxError
              when 503001 then DiandianOAuth::UpgradingError
              else DiandianOAuth::APIError
            end
        raise exception, self.message
      end
      self
    end
  end
end