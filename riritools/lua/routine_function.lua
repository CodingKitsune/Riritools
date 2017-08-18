local class = require("riritools.lua.class")
local delayed_function = require("riritools.lua.delayed_function")

local routine_function = class("rt.routine_function", delayed_function)

function routine_function:__try_delayed_function()
	if (self.__timer:as_milliseconds_left() <= 0) then
		self.__timer:restart()
		self.__function(self.__target)
	end
end

return routine_function
