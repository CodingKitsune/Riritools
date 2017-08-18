local class = require("riritools.lua.class")
local gui_draggable_bar = require("riritools.lua.gui_draggable_bar")

local gui_slider = class("rt.gui_slider", gui_draggable_bar)

function gui_slider:setup()
	gui_draggable_bar.setup(self)
	self:__setup_node("__outer_bar", "bar")
	self:__setup_node("__handle", "handle")
	self:refresh()
end

function gui_slider:update(dt)
	gui_draggable_bar.update(self, dt)
	local position = gui.get_position(self.__inner_bar)
	local size = gui.get_size(self.__inner_bar)
	if (self.__is_vertical) then
		if (self.__is_reverse) then
			position.y = position.y - size.y
		else
			position.y = position.y + size.y
		end
	else
		if (self.__is_reverse) then
			position.x = position.x - size.x
		else
			position.x = position.x + size.x
		end
	end
	gui.set_position(self.__handle, position)
end

return gui_slider
