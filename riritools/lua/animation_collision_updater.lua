local class = require("riritools.lua.class")
local d_msgs = require("riritools.lua.defold_msgs")

local enable = d_msgs.ENABLE
local disable = d_msgs.DISABLE

local animation_queue_collision_updater = class("rt.animation_queue_collision_updater")
local post = msg.post

function animation_queue_collision_updater:__initialize(first_component)
	self.__component = first_component
end

function animation_queue_collision_updater:update(new_name)
	if (self.__component ~= new_name) then
		post("#collision_"..new_name, enable)
		if (self.__component) then
			post("#collision_"..self.__component, disable)
		end
		self.__component = new_name
	end
end

return animation_queue_collision_updater
