local class = require("riritools.lua.class")
local regressive_chronometer = require("riritools.lua.regressive_chronometer")

local pairs = pairs

local delayed_function = class("rt.delayed_function")

delayed_function.static.auto_update_list = setmetatable({}, {__mode = "k"})

local delayed_function_list = delayed_function.static.auto_update_list

delayed_function.static.auto_update_function = function()
	for delayed_func, _ in pairs(delayed_function_list) do
		delayed_func:__try_delayed_function()
	end
end

function delayed_function:__initialize(secs, function_to_delay, target, is_auto_update)
	self.__function = function_to_delay
	self.__target = target
	if (is_auto_update ) then
		delayed_function_list[self] = true
		self.__timer = regressive_chronometer:new(secs, true)
	else
		self.__timer = regressive_chronometer:new(secs)
	end
	self.__timer:restart()
end

function delayed_function:__try_delayed_function()
	if (self.__timer:as_milliseconds_left() <= 0) then
		self.__timer:stop()
		self.__function(self.__target)
	end
end

function delayed_function:update(dt)
	self.__timer:update(dt)
	self:__try_delayed_function()
end

function delayed_function:stop()
	self.__timer:stop()
end

function delayed_function:restart()
	self.__timer:restart()
end

return delayed_function
