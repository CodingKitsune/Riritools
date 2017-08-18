local class = require("riritools.lua.class")

local container = class("rt.container")

function container:__initialize()
	self.__data = {}
	self.__size = 0
end

function container:size()
	return self.__size
end

function container:is_empty()
	return self.__size <= 0
end

function container:get_raw_data()
	return self.__data
end

container:include(class.mixins.cloneable)

return container
