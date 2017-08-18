local class = require("riritools.lua.class")

local hasher = class("rt.hasher")

function hasher:__initialize(secret)
	self.__secret = secret
end

function hasher:set_secret(secret)
	self.__secret = secret
end

function hasher:encode(data)
	return data
end

function hasher:decode(data)
	return data
end

return hasher
