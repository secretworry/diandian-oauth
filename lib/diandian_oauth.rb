require 'active_support/core_ext'
require 'diandian_oauth/api'
require 'diandian_oauth/client'
require 'diandian_oauth/exceptions'
require 'diandian_oauth/models/response'
require 'logger'
module DiandianOAuth
	VERSION = '0.1.1'
  module Logger
    def logger *args
      if args.empty?
        @logger
      else
        @logger = case args.first
          when ::Logger then args.first
          else ::Logger.new *args
        end
      end
    end
  end
  extend Logger
  logger STDOUT
end
