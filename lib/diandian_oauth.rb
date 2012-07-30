require 'diandian_oauth/api'
require 'diandian_oauth/client'
require 'active_support/core_ext'
require 'logger'
module DiandianOAuth
	VERSION = '0.0.1'
  module Logger
    def logger *args
      if args.empty?
        @logger
      else
        @logger = ::Logger.new *args
      end
    end
  end
  extend Logger
  logger STDOUT
end