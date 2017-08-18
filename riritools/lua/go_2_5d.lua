local class = require("riritools.lua.class")

local go_2_5d = class("rt.go_2_5d")

function go_2_5d:__initialize()
	self.__extra_z = 0
	self.__last_extra_z = 0
	self.__refresh_delay = 5
	self.__refresh_count = 0
	self:refresh_z()
end

function go_2_5d:update()
	self.__refresh_count = self.__refresh_count + 1
	if (self.__refresh_count > self.__refresh_delay) then
		self.__refresh_count = 0
		self:refresh_z()
	end
end

function go_2_5d:refresh_z()
	local position = go.get_position()
	self.__last_extra_z = self.__extra_z
	self.__extra_z = position.y * 0.000001
	position.z = position.z + self.__last_extra_z - self.__extra_z
	go.set_position(position)
end

return go_2_5d
