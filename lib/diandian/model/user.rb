module Diandian
	module Model
		class User < Diandian::Model::Base
			define_attribute_methods [:following, :likes, :blogs]
		end
	end
end