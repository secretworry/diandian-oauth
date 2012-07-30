module Diandian
	autoload :Model, 'diandian/model'
	module Model
		autoload :Base, 'diandian/model/base'
		autoload :Blog, 'diandian/model/blog'
		autoload :Post, 'diandian/model/post'
		autoload :User, 'diandian/model/user'
	end
end