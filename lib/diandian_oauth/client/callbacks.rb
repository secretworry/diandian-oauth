module DiandianOAuth
  class Client
    module Callbacks
      class Callback
        attr_accessor :executor
        def initialize proc_or_method
          self.executor = proc_or_method
        end
        def apply client, *args, &block
          case executor
            when Symbol then client.send(executor, *args, &block)
            when Proc then executor.call( client, *args, &block)
          end
        end
      end
      def self.included base
        base.extend ClassMethods
        base.send :include, InstanceMethods
        base.class_eval do
          self.callbacks = {}
        end
      end

      module ClassMethods
        def callbacks name=nil
          if name
            @callbacks[name] ||= []
          else
            @callbacks
          end
        end
        def callbacks= callbacks
          @callbacks = callbacks
        end
        def token_refreshed proc_or_method
          self.callbacks(:token_refreshed) << Callback.new( proc_or_method)
        end
        private
      end
      module InstanceMethods
        def token_refreshed uid, access_token
          self.class.callbacks[:token_refreshed].each do |callback|
            callback.apply(self, uid, access_token)
          end
        end
      end
    end
  end
end