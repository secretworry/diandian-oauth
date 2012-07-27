module Diandian
	module Model
		class Base
			include ActiveModel::AttributeMethods
			include ActiveModel::Serializers::JSON
			include ActiveModel::Validations

			def initialize( attributes = {})
				@attributes = attributes
			end

			class << self
				def model_name model_name = nil
					@model_name = model_name if model_name
					@model_name ||= self.name.downcase
				end
			end

			def model_name
				self.class.model_name
			end

			def id
				nil
			end
		end
	end
end