module Diandian
	module Model
		class Blog < Diandian::Model::Base
			define_attribute_methods [:title, :posts, :name, :updated, :description, :likes, :blogCName]

			def id
				self.blogCName
			end
		end
	end
end